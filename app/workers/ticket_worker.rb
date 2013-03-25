# -*- encoding : utf-8 -*-
#!/usr/bin/env ruby
# coding: utf-8

class TicketWorker  < BaseWorker
  def check(article_id)
    puts '===new==='
    article = Article.find article_id
    return unless article.status == 'pending'

    unless @ticket_types
      @ticket_types = {}
      TicketType.all.each do |tt|
        @ticket_types[tt.id] = tt
      end
    end
    @tickets = article.tickets.find :all, :conditions => 'ticket_type_id is not null'
    
    return if @tickets.size < 5
    scores = @tickets.collect do |t|
      tp = @ticket_types[t.ticket_type_id]
      w = t.user.ensure_weight
      we = (tp.weight > 0 ? w.pos_weight : w.neg_weight)
      tp.weight * we
    end
    scores.reject!{|i|i==0.0}
    score = scores.sum
    num = scores.size
    av = score / num
    ub = 2.0 / num - 0.1
#lb = -3.33 / num + 0.066
    lb=-3.5/num+0.2
    puts "check,#{article.id},#{@tickets.size},#{num},#{score},#{av}"
    if num < 16
      if av <= lb
        puts "reject #{article_id} due to avg #{av}"
        judge(:article_id => article_id, :approval => false)
      elsif av >= ub
        puts "accept #{article_id} due to avg #{av}"
        judge(:article_id => article_id, :approval => true)
      end
    else
      if av >= 0.02
        puts 'accept'
        judge(:article_id => article_id, :approval => true)
      else
        puts 'reject'
        judge(:article_id => article_id, :approval => false)
      end
    end
    puts '========='
  end

  def judge(options)
    article_id = options[:article_id]
    approval = options[:approval]
    
    puts "judging #{article_id}"
    article = Article.find article_id
    
    if approval
      article.publish!
    else
      article.reject!
    end

    article.tickets.each do |t|
      next unless t.ticket_type
      a = (t.ticket_type.weight > 0)
      t.correct = (a == approval)
      t.save
    end
  end
end
