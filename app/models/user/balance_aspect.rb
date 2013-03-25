# -*- encoding : utf-8 -*-
module User::BalanceAspect
  def self.included(base)
    base.class_eval do 
      has_one :balance
      alias_fallback :balance, :create_balance
      alias ensure_balance balance
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def gain_credit amount, reason = ''
      self.class.transaction(:requires_new => true)do
        balance.lock!
        balance.transactions.create :amount => amount, :reason => reason
        balance.increment!('credit', amount)
      end
    end

    def get_daily_login_salary
      if check_daily_login_salary(balance)
        gain_credit 10, 'daily_salary'
      end
    end

    def get_daily_article_salary
      articlequest=ArticleQuest.new(self)
      articlequest.finish
     # if check_daily_article_salary(balance)
     #   gain_credit 5, 'daily_article'
     # end
    end

    def get_daily_comment_salary
      if check_daily_comment_salary(balance)
        gain_credit(3, "daily_comment")
      end
    end

    def check_daily_login_salary(balance)
      daily_saraly = Transaction.find :first, :conditions => ["balance_id =? and reason=? and created_at > ?", balance.id, "daily_salary",Date.today.to_time], :order => 'created_at desc'
      if daily_saraly
        false #has already get the login_saraly
      else
        true
      end
    end
    def check_daily_article_salary(balance)
      article=Article.find :first,:conditions=>["user_id=? and created_at > ?",self.id,Date.today.to_time],:order=>'created_at desc'
      daily_article_salary = Transaction.find :first, :conditions => ["balance_id=? and reason=? and created_at > ?", balance.id ,"daily_article", Date.today.to_time ], :order => 'created_at desc'
      if article && !daily_article_salary
        true
      else
        false
      end
    end

    def check_daily_comment_salary (balance)
      comment=Comment.find :first,:conditions=>["user_id=? and created_at > ?",self.id,Date.today.to_time],:order=>'created_at desc'
      daily_comment_salary = Transaction.find :first, :conditions => ["balance_id=? and reason=? and created_at > ?", balance.id ,"daily_comment", Date.today.to_time ], :order => 'created_at desc'
      if comment && !daily_comment_salary
        true
      else
        false
      end
    end    
  end
end
