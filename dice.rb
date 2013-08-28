# Dice Class
# Author :: Alex Carvalho

class Dice
    
    @rng
    
    INITIAL_VALUE = 1
    
    DICE_PREFIX = "d"
    EXPLODE_PREFIX = "e"
    SUCCESS_PREFIX = "s"
    EXPLODE_SUCCESS_PREFIX = "x"
    
    SYMBOLS = {
        :faces => {
            :joker => {
                :value => 0,
                :name => "joker",
                :abbrev => "Jk",
            },
            :ace => {
                :value => 1,
                :name => "ace",
                :abbrev => "A",
            },
            :jack => {
                :value => 11,
                :name => "jack",
                :abbrev => "J",
            },
            :queen => {
                :value => 12,
                :name => "queen",
                :abbrev => "Q",
            },
            :king => {
                :value => 13,
                :name => "king",
                :abbrev => "K",
            }
        },
        :suits => {
            :spade => {
                :unicode => "#{[9824].pack('U*')}",
                :name => "spade",
                :plain => "<3<",
                :color => :black,
                :abbrev => "S",
            },
            :heart => {
                :unicode => "#{[9825].pack('U*')}",
                :name => "heart",
                :plain => "<3",
                :color => :red,
                :abbrev => "H",
            },
            :diamond => {
                :unicode => "#{[9826].pack('U*')}",
                :name => "diamond",
                :plain => "<>",
                :color => :red,
                :abbrev => "D",
            },
            :club => {
                :unicode => "#{[9827].pack('U*')}",
                :name => "club",
                :plain => "c3<",
                :color => :black,
                :abbrev => "C",
            }
        },
        :numbers => {
            0 => {
                :name => "zero"
            },
            1 => {
                :name => "one"
            },
            2 => {
                :name => "two"
            },
            3 => {
                :name => "three"
            },
            4 => {
                :name => "four"
            },
            5 => {
                :name => "five"
            },
            6 => {
                :name => "six"
            },
            7 => {
                :name => "seven"
            },
            8 => {
                :name => "eight"
            },
            9 => {
                :name => "nine"
            },
            10 => {
                :name => "ten"
            }
        }
    }        
            
            
            
    SUIT_SYMBOLS_UNICODE = Hash.new
    SUIT_SYMBOLS_UNICODE["spade"] = "#{[9824].pack('U*')}"
    SUIT_SYMBOLS_UNICODE["heart"] = "#{[9825].pack('U*')}"
    SUIT_SYMBOLS_UNICODE["diamond"] = "#{[9826].pack('U*')}"
    SUIT_SYMBOLS_UNICODE["club"] = "#{[9827].pack('U*')}"
    
    SUIT_SYMBOLS_PLAIN = Hash.new
    SUIT_SYMBOLS_PLAIN["spade"] = "<3<"
    SUIT_SYMBOLS_PLAIN["heart"] = "<3"
    SUIT_SYMBOLS_PLAIN["diamond"] = "<>"
    SUIT_SYMBOLS_PLAIN["club"] = "o8<"
    
    # SUIT_NAME[:spade] = "spade"
    # SUIT_NAME[:heart] = "heart"
    # SUIT_NAME[:diamond] = "diamond"
    # SUIT_NAME[:club] = "club"
    
    # COLOR_IRC[:black] = "#{[16].pack('U*')}1"
    # COLOR_IRC[:red] = "#{[16].pack('U*')}4"
    
    COIN_ROLL = ["heads", "tails"]
    FUDGE_ROLL = -1..+1
    D4_ROLL = 1..4
    D6_ROLL = 1..6
    D8_ROLL = 1..8
    D10_ROLL = 1..10
    D12_ROLL = 1..12
    D20_ROLL = 1..20
    D100_ROLL = 1..100
    
    C52_DECK = Array.new(52) { |c| unicode = 9824 + (c/13).to_i
        suit = ""
        irc_color = ""
        number = (c + 1) - ((c/13).to_i * 13)
        
        case unicode
        when 9824
            suit = "spade"
            irc_color = "#{[9824].pack('U*')}"
        when 9825
            suit = "heart"
            irc_color = "#{[9825].pack('U*')}"
        when 9826
            suit = "diamond"
            irc_color = "#{[9826].pack('U*')}"
        when 9827
            suit = "club"
            irc_color = "#{[9827].pack('U*')}"
        end
        
        case number
        when 1
            number = "A"
        when 11
            number = "J"
        when 12
            number = "Q"
        when 13
            number = "K"
        else
            number = number
        end        
        
        "#{number}#{[unicode].pack('U*')}" #"#{[unicode].pack('U*')},#{number},#{suit}"
    }
    C54_DECK = C52_DECK.push("RdJk","BkJk")
    C56_DECK = C52_DECK.push("Jk#{[9824].pack('U*')}","Jk#{[9825].pack('U*')}","Jk#{[9826].pack('U*')}","Jk#{[9827].pack('U*')}")
    
    
    def initialize()
        
        @rng = Random.new
        
    end
    
    public
    def roll(range, step=false, target=false, explosion=false, implosion=false)
        roll = nil
		result = {:rolls => Array.new, :sum => 0, :target => target, :explosion => explosion, :implosion => implosion, :successes => 0, :error => false}
        
        case range
        when Range
            if range.first.is_a? Integer
                if (step)
                    first = range.first
                    last = range.last
                    interval = last-first
                    times = interval/step
                    
                    roll = first+(@rng.rand((0..times))*step)
                else
                    roll = @rng.rand(range)
                end
            else
                values = range.to_a
                roll = values[@rng.rand(0...values.length)]
            end        
        when Array
            range.compact!
            roll = range[@rng.rand(0...range.length)]
        when Hash
            values = range.to_a
            roll = Hash[[values[@rng.rand(0...values.length)]]]
        when Integer, Float
            #TODO: add step code
            case range
            when 0
                roll = nil
                puts "#{self.class} module error: Range can't equal 0."
            when INITIAL_VALUE
                roll = INITIAL_VALUE
            else
                base = (range > INITIAL_VALUE) ? INITIAL_VALUE : 0
                value = (step) ? (range / step).to_i : range.to_i
                roll = (step) ? (base+@rng.rand(value))*step : base+@rng.rand(value)
                #roll = base+@rng.rand(value)
                #roll = value
            end
        end
        
        return roll       
        
    end
    
    def test(value, target)
        
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
    
end

x = Dice::C56_DECK
dice = Dice.new
10.times { 
    10.times { print dice.roll(x)
    print " " }
    puts ""
}
sleep(10)