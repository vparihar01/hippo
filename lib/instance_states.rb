module InstanceStates
  def self.included(base)
    base.instance_eval do
      include StateMachine

      if ( !defined?(@@STATES) ) 
        @@STATES = { 'NEW' => 1000, 'READY' => 2000,  'CANCELLED' => 3000,  'FINISHED'=> 4000,  'RUNNING' => 5000, 'FAILED' => 6000 }.freeze
      end

      state_machine :status, :initial => :new do
        state :new, :value => @@STATES['NEW']
        state :ready, :value => @@STATES['READY']
        state :cancelled, :value => @@STATES['CANCELLED']
        state :finished, :value => @@STATES['FINISHED']
        state :running, :value => @@STATES['RUNNING']
        state :failed, :value => @@STATES['FAILED']

        event :do_ready do
          transition :new => :ready
        end

        event :do_finished do
          transition :running => :finished
        end

        event :do_cancelled do
          transition [:running,:ready, :new] => :cancelled
        end

        event :do_failed do
          transition :running => :failed
        end
      end
    end
  end
end
