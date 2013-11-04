#!/usr/bin/ruby

# Dice Class
# Author :: Alex Carvalho

require "./symbols.rb"

class Dice
    
    include Symbols
    
    @rng
    
    INITIAL_VALUE = 1
    LOOP_LIMIT = 100
    
    PARSER_PREFIX = nil
    PARSER_SUFFIX = nil
    
    REPEAT_SUFFIX = "#"
    
    ROLL_PREFIXES = {
        :roll => "d",
        :explode => "e",
        :success => "s",
        :explode_success => "x",
        :deck => "t",
        :hand => "h",
        :open_pool => "c",
    }
    
    ROLL_REGEX = /(?<roll>(?<amount>\d+)(?<type>[#{ROLL_PREFIXES.values.join}])(?<range>\w+))(?<check>[!#<=>](\d+)[<=>])?/
    FORMULA_REGEX = /(?<formula>((?:\d)*(?:\.\d+)?(?:%)?[\/\*\-\+])*(?<dicecalc>(?:#{ROLL_REGEX}([\/\*\-\+]\b)?)+)((?:\d)*(?:\.\d+)?(?:%)?(?:[\/\*\-\+]\b)?)*)/
    SET_REGEX = /^\b(?:(?<repeat>\d+)#{REPEAT_SUFFIX})?(?<set>(#{FORMULA_REGEX}(;)?)+)\b/
    
    # /(?:(?<repeat>\d+)#{REPEAT_SUFFIX})?(?<formula>((?:\d+)?(?:\.\d+)?(?:%)?[\/\*\-\+])*(?<dicecalc>((?<roll>(?<amount>\d+)?(?<type>[#desx])(?<range>\w+))(?<check>[<=>](\d+)[<=>])?)([\/\*\-\+]\b)?)+((?:\d+)?(?:\.\d+)?(?:%)?(?:[\/\*\-\+]\b)?)*)/
    
    # COLOR_IRC[:black] = "#{[16].pack('U*')}1"
    # COLOR_IRC[:red] = "#{[16].pack('U*')}4"
    
    RANGES = {
        :coin => ["heads", "tails"],
        :fudge => -1..+1,
        :d2 => 1..2,
        :d4 => 1..4,
        :d6 => 1..6,
        :d8 => 1..8,
        :d10 => 1..10,
        :d12 => 1..12,
        :d20 => 1..20,
        :d100 => 1..100,
        :c52 => Array.new(52) { |c| suit = (c/13)
            number = (c + 1) - ((c/13).to_i * 13)
                
            case number
            when SYM_FACES[:ace][:value]
                number = SYM_FACES[:ace][:abbrev]
            when SYM_FACES[:jack][:value]
                number = SYM_FACES[:jack][:abbrev]
            when SYM_FACES[:queen][:value]
                number = SYM_FACES[:queen][:abbrev]
            when SYM_FACES[:king][:value]
                number = Symbols::SYM_FACES[:king][:abbrev]
            end
            
            case suit
            when 0
                suit = SYM_SUITS[:spade][:unicode]
            when 1
                suit = SYM_SUITS[:heart][:unicode]
            when 2
                suit = SYM_SUITS[:diamond][:unicode]
            when 3
                suit = SYM_SUITS[:club][:unicode]
            end
            
            
            "#{number}#{suit}"
        },
        :rolls => ["face", "back", "side"],
        :sex => ["YES!", "Sure!", "Yup!"],
        :gender => ["male", "female"],
        :pony => ["earth pony", "pegasus", "unicorn"],
    }
    RANGES[:c54] = Array.new(RANGES[:c52]).push("#{SYM_COLORS[:red][:abbrev]}#{SYM_FACES[:joker][:abbrev]}","#{SYM_COLORS[:black][:abbrev]}#{SYM_FACES[:joker][:abbrev]}")
    RANGES[:c56] = Array.new(RANGES[:c52]).push(*SYM_SUITS.collect{ |key,suit| "#{SYM_FACES[:joker][:abbrev]}#{suit[:unicode]}"})
    
    
    MINOR_ARCANA_DECK = Array.new
    MAJOR_ARCANA_DECK = Array.new 
    
    TAROT_DECK = Array.new
    
    @decks = # {:id => {:owner, :location, :time, :deck}}
    
    def initialize()
        
        reset_seed()
        
    end
    
    public
    def reset_seed()
        
        @rng = Random.new
        
    end
    
    def roll(range, amount=1, step=false, target=false, handicap=false, explosion=false, msg=false)
        # HACK: The roll loops should be made into functions
        roll = nil
    	result = {:rolls => Array.new, :sum => 0, :target => target, :handicap => handicap, :explosion => explosion, :successes => 0, :error => false, :msg => msg}
        
        loop_count = 0
        
        case range
        when Range
            if range.first.is_a? Integer
                if (step)
                    first = range.first
                    last = range.last
                    interval = last-first
                    times = interval/step
                    rolled = 0
                    begin
                        loop_count += 1
                        roll = first+(@rng.rand((0..times))*step)
                        result[:rolls] = result[:rolls].push(roll)
                        result[:sum] += roll
                        result[:successes] += 1 if success?(roll,target)
                        result[:successes] -= 1 if success?(roll,handicap)                        
                        exploded = success?(roll,explosion)
                        amount += 1 if exploded
                        rolled += 1
                    end while (rolled < amount) && (loop_count < LOOP_LIMIT)
                else
                    rolled = 0
                    begin
                        loop_count += 1
                        roll = @rng.rand(range)
                        result[:rolls] = result[:rolls].push(roll)
                        result[:sum] += roll
                        result[:successes] += 1 if success?(roll,target)
                        result[:successes] -= 1 if success?(roll,handicap)                        
                        exploded = success?(roll,explosion)
                        amount += 1 if exploded
                        rolled += 1
                    end while (rolled < amount) && (loop_count < LOOP_LIMIT)
                end
            else
                values = range.to_a
                rolled = 0
                begin
                    loop_count += 1
                    roll = values[@rng.rand(0...values.length)]
                    result[:rolls] = result[:rolls].push(roll)
                    result[:successes] += 1 if success?(roll,target)
                    result[:successes] -= 1 if success?(roll,handicap)                        
                    exploded = success?(roll,explosion)
                    amount += 1 if exploded
                    rolled += 1
                end while (rolled < amount) && (loop_count < LOOP_LIMIT)
                result[:sum] = result[:rolls].count
            end        
        when Array
            range.compact!
            rolled = 0
            begin
                loop_count += 1
                roll = range[@rng.rand(0...range.length)]
                result[:rolls] = result[:rolls].push(roll)
                result[:successes] += 1 if success?(roll,target)
                result[:successes] -= 1 if success?(roll,handicap)                        
                exploded = success?(roll,explosion)
                amount += 1 if exploded
                rolled += 1
            end while (rolled < amount) && (loop_count < LOOP_LIMIT)
            result[:sum] = result[:rolls].count            
        when Hash
            values = range.to_a
            rolled = 0
            begin
                loop_count += 1
                roll = Hash[[values[@rng.rand(0...values.length)]]]
                result[:rolls] = result[:rolls].push(roll)
                result[:successes] += 1 if success?(roll,target)
                result[:successes] -= 1 if success?(roll,handicap)                        
                exploded = success?(roll,explosion)
                amount += 1 if exploded
                rolled += 1
            end while (rolled < amount) && (loop_count < LOOP_LIMIT)
            result[:sum] = result[:rolls].count          
        when Integer, Float
            #TODO: add step code
            case range
            when 0
                roll = nil
                result[:rolls] = ["0-sided die rolled: Universe #{target_universe} destroyed"]
                result[:error] = Array.new if !result[:error]
                puts "#{self.class} module error: Range can't equal 0."
                result[:error] = result[:error].push("Invalid Range of 0")
            when INITIAL_VALUE
                rolled = 0
                begin
                    loop_count += 1
                    roll = INITIAL_VALUE
                    result[:rolls] = result[:rolls].push(roll)
                    result[:sum] += roll
                    result[:successes] += 1 if success?(roll,target)
                    result[:successes] -= 1 if success?(roll,handicap)
                    rolled += 1
                end while (rolled < amount) && (loop_count < LOOP_LIMIT)
                if explosion
                    result[:error] = Array.new if !result[:error] 
                    puts "#{INITIAL_VALUE}-sided dice prevented from explosion to avoid infinite loops"
                    result[:error] = result[:error].push("#{INITIAL_VALUE}-sided dice should not explode")
                end
                if success?(roll,explosion)
                    result[:rolls] = result[:rolls].push("...and it goes on forever") 
                    result[:sum] = Float::INFINITY
                end
            else
                base = (range > INITIAL_VALUE) ? INITIAL_VALUE : 0
                value = (step) ? (range / step).to_i : range.to_i
                rolled = 0
                begin
                    loop_count += 1
                    roll = (step) ? (base+@rng.rand(value))*step : base+@rng.rand(value)
                    result[:rolls] = result[:rolls].push(roll)
                    result[:sum] += roll
                    result[:successes] += 1 if success?(roll,target)
                    result[:successes] -= 1 if success?(roll,handicap)
                    exploded = success?(roll,explosion)
                    amount += 1 if exploded
                    rolled += 1
                end while (rolled < amount) && (loop_count < LOOP_LIMIT)
            end
        end
        
        if loop_count >= LOOP_LIMIT
           result[:error] = Array.new if !result[:error]
           result[:error] = result[:error].push("Exceeded explosion limit of #{LOOP_LIMIT}")            
        end
        
        return result 
        
    end
    
    def success?(value, target)
        
        equal = false
        
        case target
        when Range, Array
            equal = target.include?(value)            
        when Hash
            equal = target.value?(value)
        when Integer, Float
            equal = target == value
        when String
            equal = target.upcase.chomp == value.upcase.chomp
        end
        
        return equal
        
    end
    

    def parse_set(set,user = nil,location = nil)
        
        set_parser = set.match(SET_REGEX)
        
        result = []
        
        repeat = (set_parser[:repeat])? set_parser[:repeat].to_i : 1
        
        for s in Range.new(1,repeat)
            
            f_set = matches(set_parser[:set],FORMULA_REGEX)
            
            for f_parser in f_set
            
                d_set = matches(f_parser[:dicecalc],ROLL_REGEX)   
                
                for d_parser in d_set
                
                    amount = (d_parser[:amount])? d_parser[:amount].to_i : 1
                    
                        numeric  = d_parser[:range] =~ /^\d+$/
                        range_id = (numeric)? "d#{d_parser[:range]}".to_sym : "#{d_parser[:range]}".to_sym
                        
                        if !RANGES[range_id].nil?
                            range = RANGES[range_id]
                        elsif numeric
                            range = d_parser[:range].to_i
                        else
                            range = ["?"]
                        end
                        
                        result.push(roll(range),amount)
                    
                end
                
            end
            
        end
        
        return result
        
    end
    
    def set_to_s(set,mode)
        
    
    end
    
    def parse_to_s()
        
    end
    
    # Function by Stack Overflow's mu is too short
    # http://stackoverflow.com/questions/9528035/ruby-stringscan-equivalent-to-return-matchdata
    def matches(s, re)
        start_at = 0
        matches  = [ ]
        while(m = s.match(re, start_at))
            matches.push(m)
            start_at = m.end(0)
        end
        return matches
    end
        
    def target_universe
        hypersector = @rng.rand(899) + 100
        hypersector = hypersector.to_s.split('').map { |digit| digit.to_i }
        hypersector[0] *= 100
        hypersector[1] *= 10
        hypersector.collect! { |digit|
            char = SYM_GREEKS.select { |key,value| value[:value] == digit }
            digit = (char.values[0])? char.values[0][:upper] : nil
        }
        return "#{hypersector.join}-#{@rng.rand(8999)+1000}"
        
    end
    
    protected 
    def _roll_loop_num(result)
        #One day I'll get this up to shape
    end
    
    def _roll_loop_obj(result)
        
        
    end
    
end

# puts x = Dice::SET_REGEX.to_s
# dice = Dice.new
# puts dice.parse_set("3#1dcoin").collect {|s| s[:rolls][0]}.inject(:+)
#dice.parse_set("1d12+1d6+10;1d4")
puts ""
#dice.parse_set("2#2d6;3d4")
puts ""
# 10.times { 
#     # puts dice.roll(x)[:rolls]
#      10.times { print dice.roll(x)[:rolls][0]
#      print " " }
#      puts ""
# }
sleep(10)