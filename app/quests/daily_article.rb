
class Quest::DailyArticle < Quest
  title '每日发贴'
  description 'test'
  reward_credit 10
  cycle :day
  check 'no article detected' do |user|
    today = Date.today
    c =  user.articles.count :conditions => ["created_at >= ? and created_at < ?", today, today + 1]
    c > 0
  end
end