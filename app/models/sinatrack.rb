class Sinatrack
  include HTTParty
  # include Subexec
  base_uri 'api.t.sina.com.cn'
  #这里的微薄帐号，密码，和所对应的网站的group_id要在这里设置一下，顺序不要错了
  #@username = ["zuikeai2011@hotmail.com"]
  #@password = ["zuikeai"]
  #@groups=[9]
  WEIBO_USERNAME= @username = ["gezhong@hotmail.com"]
  WEIBO_PASSWORD= @password = ["nirvanaadmin"]
  WEIBO_SOURCE = @source=1228964861
  @groups=[9]
  #zuikeai2011@hotmail.com
  #zuikeai
  # options[:query] can be things like since, since_id, count, etc.
  #获取最新的公共微博消息
  
  class << self
    def weibo_username
      Setting.weibo_username
    end
    
    def timeline()
      basic_auth Setting.weibo_username, Setting.weibo_password
      get("/statuses/friends_timeline.json?source=#{@source}&count=1&page=1").parsed_response
      #  end
    end
    
    #本人发的所有帖子列表
    def user_timeline
      get("/statuses/user_timeline.json?source=#{@source}&count=200&page=1").parsed_response
    end
    
    def my_id
      get("/statuses/user_timeline.json?source=#{@source}&count=200&page=1").parsed_response[0]["user"]["id"]
    end
    
    #本人关注的所有好友的帖子列表
    def friends_friendship
      basic_auth @username[0],@password[0]
      get("/statuses/friends_timeline.json?source=#{@source}")
    end
    
    def sinapost article_id
      article=Article.find(article_id)
      if article.picture.file?
        upload(article_id,article.picture.url,article.content)
      else
        postnew(article_id,article.content)
      end
    end
    
    #发布一个新的微博客消息，这里在返回数据中会有这个帖子的id，帖子id在html中是看不到的
    def postnew(article_id,text)
      (0...@username.length).to_a.each  do |i|
        basic_auth @username[i],@password[i]
        options = { :query => {:status => text} }
        tmp=post("/statuses/update.json?source=#{@source}", options).parsed_response
        if tmp["error"].nil?
          ArticleTrackback.create(:article_id=>article_id,:trackback_id=>tmp["id"],:platform=>"sina",:link=>"t.sina.com/#{tmp['id']}/profile")
        end
      end
    end
    
    #根据帖子id得到这个帖子的所有评论，并且放在本地数据库里
    def comments
      latest=Comment.find(:first,:conditions => [ "name is NOT  NULL  "],:order=>"created_at DESC")
      basic_auth @username[0],@password[0]
      as=   ArticleTrackback.find(:all)
      as.each do |a|
        tmp=get("/statuses/comments.json?source=#{@source}&id=#{a.trackback_id}&count=20&page=1").parsed_response
        if tmp.is_a?(Array)
          tmp.each do |b|
            #选择此贴子来自新浪的评论中的时间最晚的一条
            aa=Time.parse  b["created_at"]
            #如果此帖子还没有新浪的评论，或者新获取的评论比最新的评论还要新
            if latest.nil? || (!latest.nil?&&(aa<=>  latest.created_at)==1)
              Comment.create(
                :content=> b["text"],
                :article_id=> a.article_id,
                :created_at => aa,
                :status => "publish",
                :anonymous => 0,
                :name=>  b["user"]["name"],
                :link => "t.sina.com/"+b["user"]["id"].to_s+"/profile")
            end
            sleep(1)
          end
        end
      end
    end
    
    #根据帖子id得到所有内容
    def content(id)
      get("/statuses/show/:#{id}.json?source=#{@source}").parsed_response
    end
    
    #获取用户关注列表及每个关注用户最新一条微博
    def friends(user_id)
      basic_auth @username[0],@password[0]
      get("/statuses/friends/#{user_id}.json?source=#{@source}&count=200").parsed_response
    end
    
    #获取用户粉丝列表及及每个粉丝用户最新一条微博
    def followers(user_id)
      get("/statuses/followers/#{user_id}.json?source=#{@source}").parsed_response
    end
    
    #发送私信
    def direct_message(user_id,text)
      options = {:query => {:id=>user_id,:text => text} }
      post("/direct_messages/new.json?source=#{@source}", options).parsed_response
    end
    
    #返回一条原创微博消息的最新n条转发微博消息
    def repost_timeline (id)
      get("/statuses/repost_timeline.json?source=#{@source}&id=#{id}&page=1").parsed_response
    end
    
    def reply_to_comment(id,comment_id,text)
      options = {:query => {:id=>id,:cid=>comment_id,:comment => text} }
      post("/statuses/reply.json?source=#{@source}", options).parsed_response
    end
    
    def followone(id)
      options = {:query => {:user_id=>id} }
      post("/friendships/create.json?source=#{@source}",options).parsed_response
    end
    
    def rate_limit_status
      basic_auth @username[0],@password[0]
      get("/account/rate_limit_status.json?source=#{@source}").parsed_response
    end
    
    def upload(article_id,pic,text)
      text||="来自http://zuikeai.net/articles/#{article_id}的好图"
      path = File.join Rails.public_path, pic.split("?")[0]
      (0...@username.length).to_a.each  do |i|
        str="curl -u '#{@username[i]}:#{@password[i]}' -F 'pic=@#{path}' -F 'status=#{text}' 'http://api.t.sina.com.cn/statuses/upload.json?source=1228964861'"
        system(str)
        if timeline[0]["text"]==text
          tmp=timeline[0]
        else
          tmp= {"error"=>"error"}
        end
        if tmp["error"].nil?
          ArticleTrackback.create(:article_id=>article_id,:trackback_id=>tmp["id"],:platform=>"sina",:link=>"t.sina.com/#{tmp['user']['id']}/profile")
        end
      end
    end
    
    #得到收藏的帖子
    def favorites
      basic_auth @username[0],@password[0]
      get("/favorites.json?source=#{@source}").parsed_response
    end
    
    #批量删除对帖子的收藏
    def destroy_batch_favorites(ids)
      post("/favorites/destroy_batch.json?source=#{@source}&ids=#{ids.join(',')}")
    end
    
    #得到帐号收藏的帖子，同步发表到网站内容上面去
    def fetch_favorites
      (0...@username.length).to_a.each  do |i|
        basic_auth @username[i],@password[i]
        group_id=@groups[i]
        results=self.favorites
        ids = []
        # results = sina_api.favorites(i)
        if results.size != 0
          results.each do  |r|
            #这里把这个帖子的内容放进网站的帖子articles数据库
            content=r["retweeted_status"].nil?? r["text"] : r["retweeted_status"]["text"]
            url=r["retweeted_status"].nil?? r["original_pic"] : r["retweeted_status"]["original_pic"]
            if url.nil?
              Article.create(:content=>content,
                :group_id=>9,
                :status=>"publish",
                :anonymous=>1)
            else
              filename=url.split("/")[-1]
              system("curl #{url} --o '/tmp/#{filename}'")
              Article.create(:content=>content,
                :picture=>File.open("/tmp/#{filename}"),
                :group_id=>group_id,
                :status=>"publish",
                :anonymous=>1)
              File.delete("/tmp/#{filename}")
            end
            ids<< r["id"]
            sleep 2
          end
        end
        self.destroy_batch_favorites(ids)
      end
    end
    
    def create_friendship(id)
      post("/friendships/create/#{id}.json?source=#{@source}").parsed_response
    end
    
    def destroy_friendship(id)
      post("/friendships/destroy/#{id}.json?source=#{@source}").parsed_response
    end
    
    def clear_friendship
      ids=[1960731727]#这个id是zuikeai2011@hotmail.com的用户id，这个要填写需要保留的关注的人的id
      myfriends=[]
      a=friends(my_id)
      a.each do |c|
        myfriends << c["id"]
      end
      
      myfriends.each do |id|
        destroy_friendship(id) unless ids.include?(id)
      end
    end
  end
end
