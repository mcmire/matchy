module Matchy
  module Expectations
    module TestCaseExtensions
      # Checks if the given block alters the value of the block attached to change
      #
      # ==== Examples
      #   lambda {var += 1}.should change {var}.by(1)
      #   lambda {var += 2}.should change {var}.by_at_least(1)
      #   lambda {var += 1}.should change {var}.by_at_most(1)
      #   lambda {var += 2}.should change {var}.from(1).to(3) if var = 1
      def change(&block)
        build_matcher(:change) do |receiver, matcher, args|
          before, done, after = block.call, receiver.call, block.call
	  change_description = ''
          comparison = if list = matcher.chained_messages
	    message = list.first
	    arg = message.args.first
	    name = message.name
	    change_description = " #{name.to_s.gsub('_', ' ')} #{arg.inspect}"
            case name
            when :by          then (after == before + arg || after == before - arg)
            when :by_at_least then (after >= before + arg || after <= before - arg)
            when :by_at_most  then (after <= before + arg && after >= before - arg)
            when :from        then (before == arg) && (after == list[1].args[0])
            end
	  else
	    after != before
          end
          matcher.positive_failure_message = "given block should alter the given value#{change_description};\n  was #{before.inspect},\n  now #{after.inspect}"
	  matcher.negative_failure_message = "given block should not alter the given value#{change_description};\n  was: #{before.inspect},\n  now: #{after.inspect}"
          comparison
        end
      end
    end
  end
end
