#!/usr/bin/ruby
# encoding: utf-8

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
    
    ROLL_REGEX = /(?<roll>(?<amount>\d+)(?<type>[#{ROLL_PREFIXES.values.join}])(?<range>\w+))(?<check>[!<=>](\d+)[<=>])?/
    FORMULA_REGEX = /(?<formula>((?:\()?(?:\d)*(?:\.\d+)?(?:%)?(?:\))?[\/\*\-\+\^])*(?<dicecalc>(?:#{ROLL_REGEX}([\/\*\-\+\^\%]\b)?)+)((?:\()?(?:\d)*(?:\.\d+)?(?:%)?(?:\))?(?:[\/\*\-\+\^]\b)?)*)/
    SET_REGEX = /^\b(?:(?:(?<repeat>\d+)#{REPEAT_SUFFIX})?(?<set>(#{FORMULA_REGEX}))+(?:[\;\,])?)+\b/
    
    DIGITS_REGEX = /\d+(?:\.\d+)?/i
    ALPHAWORD_REGEX = /(?:[A-Za-z_\.][A-Za-z_\.]+|[A-Za-z_])/i
    
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
        :cmajor => Array.new(22) { |c| 
            
            number = c
            over = (number > 20) ? number % 20 : nil 
            number = number - over if over
            number = SYM_NUMBERS[number][:roman]
            over = SYM_NUMBERS[over][:roman] if over
            
            "#{number}#{over}: #{SYM_TAROT[:major][c][:name]}"
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
        
        if amount == 0
            result[:rolls].push(0)
            return result
        end
        
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
    

    def parse_set(set,user = nil,origin = nil)
        
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
                        
                        result.push(roll(range,amount))
                    
                end
                
            end
            
        end
        
        return result
        
    end
    
    def parse_set2(set_query,user = nil,origin = nil)
        
        # result = {
        #      :query => "#{set_query_query}",
        #     :sentences => [{
        #         :query => "",
        #         :repetition => 0,
        #         :instances => [{
        #             :query => "",
        #              :hands => [],
        #              :text => "",
        #             :solution => false, 
        #          }]
        #     }],
        #     :user => user,
        #     :origin => origin
        #}
        
        set_query = set_query.match(SET_REGEX).to_s
        queries = set_query.split(/[;,]/)
        
        
        result = Hash.new
        result[:query] = set_query
        result[:user] = user if user
        result[:origin] = origin if origin
        result[:sentences] = Array.new
        
        for q in queries
            
            sentence_parser = q.match(SET_REGEX)
            
            sentence = Hash.new
            sentence[:query] = sentence_parser[:set].to_s
            sentence[:repetition] = (sentence_parser[:repeat])? sentence_parser[:repeat].to_i : 1
            sentence[:instances] = Array.new
            
            for i in 0...sentence[:repetition]
                
                formula_parser = sentence[:query].match(FORMULA_REGEX)
                
                instance = Hash.new
                instance[:query] = formula_parser.to_s
                instance[:text] = instance[:query].dup
                instance[:solution] = false
                instance[:hands] = Array.new
                
                hand_queries = matches(instance[:query],ROLL_REGEX)
                
                for hand_parser in hand_queries
                    
                    amount = (hand_parser[:amount])? hand_parser[:amount].to_i : 1
                    
                    numeric  = hand_parser[:range] =~ /^\d+$/
                    range_id = (numeric)? "d#{hand_parser[:range]}".to_sym : "#{hand_parser[:range]}".to_sym
                    
                    if !RANGES[range_id].nil?
                        range = RANGES[range_id]
                    elsif numeric
                        range = hand_parser[:range].to_i
                    else
                        range = ["?"]
                    end
                    
                    dice_roll = roll(range,amount)
                    
                    if dice_roll[:rolls].first.is_a?(Numeric)
                        
                        instance[:text].sub!(hand_parser.to_s,dice_roll[:sum].to_s)
                        
                    else
                       
                        instance[:text].sub!(hand_parser.to_s,dice_roll[:rolls].join(","))
                        instance[:text].sub!("**","^")
                        
                    end
                    
                    instance[:hands].push(dice_roll)
                    
                end
                
                instance[:solution] = _eval_formula(instance[:text])
                
                sentence[:instances].push(instance)
                
            end
            
            result[:sentences].push(sentence)
            
        end
        
        return result
        
    end
    
    def parse_to_s(set_query,user = nil,origin = nil,mode = nil) # TODO: Make mode do things
        
        set = parse_set2(set_query,user = nil,origin = nil)
        reply = ""
        
        for s in set[:sentences]
            
            query = "#{s[:query]} = "
            query = "#{s[:repetition]}##{query}" if (s[:repetition]>1)
            
            for i in s[:instances]
                
                if i[:solution]
                   query = "#{query}#{i[:solution]};"
                else
                   query = "#{query}#{i[:text]};"
                end
                
            end
            
            query.sub!(/;$/," ")
            query = "#{query}["
            
            for i in s[:instances]
                
                
                for h in i[:hands]
                    
                    query = "#{query}#{h[:rolls].join(',')};"
                    
                end
                
                query.sub!(/;$/,"|")
                
            end
            
            query.sub!(/[;|]$/,"")
            query = "#{query}]. "
            
            reply = "#{reply}#{query}"
            
        end
        
        return reply
        
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
    
    def _eval_formula(formula,args = {})
        
        formula.gsub!(/(?<![\w\d])\./i,"0.")
        
        formula.gsub!("%","/100")
        formula.gsub!("^","**")
        
        args.each {|k,v|
            formula.gsub!(k.to_s,v.to_s)
        }
        
        formula.gsub!(/(?:#{DIGITS_REGEX}#{ALPHAWORD_REGEX}|#{ALPHAWORD_REGEX}#{DIGITS_REGEX})/i) {|m| 
            m.match(DIGITS_REGEX)[0]
        }
        
        # formula.gsub!(/(?:(?<=[\*\/])#{ALPHAWORD_REGEX}|#{ALPHAWORD_REGEX}(?=[\*\/]))/i) {|m| 
        #     "1"
        # }
        
        # formula.gsub!(/(?:(?<=[\+\-])#{ALPHAWORD_REGEX}|#{ALPHAWORD_REGEX}(?=[\+\-]))/i) {|m| 
        #     "0"
        # }
        
        formula = "0+#{formula}"
        
        if _test_eval(formula)
            return eval(formula)
        else
            return false
        end
    end
    
    def _test_eval(code)
        begin
            eval(code)
            return true
        rescue Exception => e
            return false
        end
    end
    
end
d = Dice.new
