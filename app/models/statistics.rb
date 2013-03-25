# -*- encoding : utf-8 -*-
class Statistics < ActiveRecord::Base
  serialize :article_ids
  serialize :score
  #  def self.new_record  #create the yesterday record
  #     date=Date.today-1
  #    create(
  #      :date            =>date,
  #      :articles        =>Article.all_number(date),
  #      :publish_articles=>Article.passed_number(date),
  #      :comments        =>Comment.all_number(date),
  #      :new_users       =>User.all_number(date),
  #      :created_at      =>Time.now,
  #      :updated_at      =>Time.now)
  #  end
  def self.create_10_min_record
    time=Time.now 
    create(
      :time=>time,
      :limit=>"10_min",
      :article_ids=>Score.find(:first,:order=>"score DESC").article_id,
      :score=>Score.find(:first,:order=>"score DESC").score)
  end
  def self.create_30_min_record
    time=Time.now
    create(
      :time=>time,
      :limit=>"30_min",
      :article_ids=>Score.find(:first,:order=>"score DESC").article_id,
      :score=>Score.find(:first,:order=>"score DESC").score
    )
 
  end
  def self.create_2_hours_record
    time=Time.now
    create(
      :time=>time,
      :limit=>"2_hours",
      :article_ids=>Score.find(:first,:order=>"score DESC").article_id,
      :score=>Score.find(:first,:order=>"score DESC").score
    )
  end
  
  def self.create_6_hours_record
    time=Time.now
    create(
      :time=>time,
      :limit=>"6_hours",
      :article_ids=>Score.find(:first,:order=>"score DESC").article_id,
      :score=>Score.find(:first,:order=>"score DESC").score
    )
  end

  def self.create_24_hours_record
    time=Time.now
    ids =[]
    scores=[]
    Score.find(:all,:order=>"score DESC",:select=>'article_id, score',:limit=>30).each do |c|
      ids << c.article_id
      scores << c.score
    end
    create(
      :time=>time,
      :limit=>"24_hours",
      :article_ids=>ids,
      :score=>scores
    )
    @table = Rufus::Tokyo::Cabinet.new(File.join(RAILS_ROOT,'db',"top_article.tch"))
  
    Article.find(ids).each do |c|
      unless @table[c.id]
        if c.email
          @invitation_code = InvitationCode.generate 1, 1
          UserNotifier.invitation_code_anonymous(c.email,@invitation_code[0].code,c.id).deliver
        elsif c.user
          @invititation_code=InvitationCode.generate c.user.id, 1
          UserNotifier.invitation_code_anonymous(c.user.email,@invititation_code[0].code,c.id).deliver
        end
        @table[c.id]=1
      end
    end
    @table.close
  end

  def self.make_statistics
    create_10_min_record
    create_30_min_record
    create_2_hours_record
    create_6_hours_record
    create_24_hours_record
  end

end
