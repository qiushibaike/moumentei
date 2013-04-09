# -*- encoding : utf-8 -*-
class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket_type
  belongs_to :article
  after_create :update_counter
  after_save :update_correct
  def self.article_score(article_id)
    article = Article.find article_id
    @tickets = article.tickets.find :all
    return 0.0 unless @tickets
    score = 0.0
    @tickets.each do |t|
      next if not t.ticket_type_id 
      tp = t.ticket_type
      w = t.user.weight
      score += tp.weight * (tp.weight > 0 ? w.pos_weight : w.neg_weight)
    end
    score 
  end
  def self.stats
    t = Time.parse ENV['DATE']
    @articles = Article.find :all, :conditions => ['created_at >= ? and created_at < ?', t, t+24.hours]
    @articles.each do |a|
      puts "#{a.id}, #{article_score(a.id)}"
    end
  end
  def self.dump
    Ticket.paginated_each(:conditions => "created_at >='2010-6-1'") do |a|
      puts "#{a.id}, #{a.user_id}, #{a.correct}, #{a.ticket_type_id}, #{a.ticket_type ? a.ticket_type.weight : ''}, #{a.created_at}, #{a.user.ensure_weight.ratio}," + \
        "#{a.ticket_type ? (a.ticket_type.weight > 0 ? a.user.ensure_weight.pos_weight : a.user.ensure_weight.neg_weight ) : '' }"
    end
  end
  protected
  def update_counter
    if ticket_type
      w = user.weight
      transaction do
        w.lock!
        w.update_all
#        if ticket_type.weight > 0
#          w.increment :pos
#        else
#          w.increment :neg
#        end
        w.save
      end
    end
  end
  def update_correct
    if correct_changed?
      w = user.weight
      transaction do
        w.lock!
        w.update_all
#        if correct
#          w.increment :correct
#          if ticket_type.weight > 0
#            w.increment :pos_correct
#          else
#            w.increment :neg_correct
#          end
#        else
#          w.decrement :correct
#          if ticket_type.weight > 0
#            w.decrement :pos_correct
#          else
#            w.decrement :neg_correct
#          end
#        end
        w.save!
      end
    end
  end
end
