# Dice Class
# Author :: Alex Carvalho

class Dice
    
    @rng
    
    INITIAL_VALUE = 1
    
    DICE_PREFIX = "d"
    EXPLODE_PREFIX = "e"
    SUCCESS_PREFIX = "s"
    EXPLODE_SUCCESS_PREFIX = "x"
    
    COIN_ROLL = ["heads", "tails"]
    FUDGE_ROLL = -1..+1
    D4_ROLL = 1..4
    D6_ROLL = 1..6
    D8_ROLL = 1..8
    D10_ROLL = 1..10
    D12_ROLL = 1..12
    D20_ROLL = 1..20
    D100_ROLL = 1..100
    
    def initialize()
        
        @rng = Random.new
        
    end
    
    public
    def roll(range, step=false, success=false, explosion=false, deduct=false)
        roll = nil
        
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
                puts "Dice module error: Range can't equal 0." #TODO: Make message use class name
            when INITIAL_VALUE
                roll = INITIAL_VALUE
            else
                base = (range > INITIAL_VALUE) ? INITIAL_VALUE : 0
                value = (step) ? (range/step) : range - base
                roll = (step) ? (base+@rng.rand(value))*step : base+@rng.rand(value)
            end
        end
        
        return roll
        
        
    end
    
end

#x = Dice::FUDGE_ROLL
dice = Dice.new