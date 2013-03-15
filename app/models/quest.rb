
class Quest 
  cattr_accessor :quests
  @@quests = { }
  def initialize(user)
    @user = user
  end
  
  def self.inherited(subclass)
    if subclass.name =~ /::(\w+)$/
      quests[$1] = subclass
    else
      quests[subclass.name] = subclass
    end
  end

  def check
    self.class.prerequisites.each do |reason, block|
      raise reason unless block.call @user
    end
    return true
  end

  def complete
    @user.global_lock "quest#{@user.id}", 3 do
      @user.transaction do
        return unless check
        s, e = self.class.time_range
        log = @user.quest_logs.find :first, [
          'quest_id = ? and created_at >= ? and created_at < ?',
          self.class.name, s, e
        ], :lock => true
        log ||= @user.quest_logs.new :quest_id => self.class.name, :status => 'accepted'
        raise 'already completed' if log.status == 'accomplished'

        self.class.rewards.each do |b|
          b.call @user, log
        end

        log.status = 'accomplished'
        log.save!
      end
    end
  end

  def accomplished?
    s, e = self.class.time_range
    log = @user.quest_logs.find :first, [
          'quest_id = ? and created_at >= ? and created_at < ?',
          self.class.name, s, e
        ]
    log && log.status == 'accomplished'
  end

  def accept
    @user.quest_logs.create :quest_id => self.class.name
  end

  class << self
    def options
      @options ||= {
        :prerequisites => {},
        :rewards => [],
        :cycle => :once
        }
    end

    def time_range
      case @options[:cycle]
      when :day
        t= Date.today
        [t, t+1]
      end
    end

    def each &block
      quests.each_pair &block
    end

    def prerequisites
      options[:prerequisites]
    end

    def rewards
      options[:rewards]
    end

    def check reason=nil, &block
      prerequisites[reason] = block
    end

    def reward_credit(amount)
      rewards << Proc.new {|user, log|
        user.gain_credit amount, log.quest_id
      }
    end

    def reward &block
      rewards << block
    end

    def description(d=nil)
      d ? options[:description] =  d : options[:description]
    end

    def title(t=nil)
      t ? options[:title] = t : options[:title]
    end

    def cycle(c)
      options[:cycle] = c
    end

    def accept(user)
      new(user).accept
    end

    def to_param
      @qid ||= name.split(/::/)[-1]
    end
  end
end


Dir[Rails.root.join('app', 'quests', "**/*.rb")].each do |f|
  n = File.basename(f, '.rb')
  cn = n.camelize
  if(Quest.const_defined?(cn))
    Quest.const_remove(cn)
  end
  load f
end
