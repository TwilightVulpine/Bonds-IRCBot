#!/usr/bin/ruby

# Symbols Module
# Author :: Alex Carvalho

module Symbols

    SYM_COLORS = {
        :white => {
            :rgb => "#FFFFFF",
            :name => "white",
            :irc => "#{[0x16].pack('U*')}0",
            :abbrev => "Wht",          
        },
        :grey => {
            :rgb => "#848484",
            :name => "grey",
            :irc => "#{[0x16].pack('U*')}14",
            :abbrev => "Gry",          
        },
        :silver => {
            :rgb => "#C6C6C6",
            :name => "silver",
            :irc => "#{[0x16].pack('U*')}15",
            :abbrev => "Slv",          
        },
        :black => {
            :rgb => "#000000",
            :name => "black",
            :irc => "#{[0x16].pack('U*')}1",
            :abbrev => "Blk",          
        },        
        :brown => {
            :rgb => "#844200",
            :name => "brown",
            :irc => "#{[0x16].pack('U*')}5",
            :abbrev => "Brn",          
        },
        :red => {
            :rgb => "#FF0000",
            :name => "red",
            :irc => "#{[0x16].pack('U*')}4",
            :abbrev => "Red",          
        },
        :orange => {
            :rgb => "#FF8400",
            :name => "orange",
            :irc => "#{[0x16].pack('U*')}7",
            :abbrev => "Org",          
        },
        :yellow => {
            :rgb => "#FFFF00",
            :name => "yellow",
            :irc => "#{[0x16].pack('U*')}8",
            :abbrev => "Ylw",          
        },        
        :lime => {
            :rgb => "#84FF00",
            :name => "lime",
            :irc => "#{[0x16].pack('U*')}9",
            :abbrev => "Lim",          
        },
        :green => {
            :rgb => "#00FF00",
            :name => "green",
            :irc => "#{[0x16].pack('U*')}3",
            :abbrev => "Grn",          
        },
        :teal => {
            :rgb => "#00ff84",
            :name => "teal",
            :irc => "#{[0x16].pack('U*')}10",
            :abbrev => "Tel"
        },
        :aqua => {
            :rgb => "#00FFFF",
            :name => "aqua",
            :irc => "#{[0x16].pack('U*')}11",
            :abbrev => "Aqa",          
        },        
        :royal_blue => {
            :rgb => "#0084FF",
            :name => "royal blue",
            :irc => "#{[0x16].pack('U*')}12",
            :abbrev => "lBl",          
        },
        :blue => {
            :rgb => "#0000FF",
            :name => "blue",
            :irc => "#{[0x16].pack('U*')}2",
            :abbrev => "Blu",          
        },
        :purple => {
            :rgb => "#8400FF",
            :name => "purple",
            :irc => "#{[0x16].pack('U*')}6",
            :abbrev => "Ppl",          
        },
        :fuchsia => {
            :rgb => "#FF00FF",
            :name => "fuchsia",
            :irc => "#{[0x16].pack('U*')}13",
            :abbrev => "Fcs"
        },
        :none => {
            :irc => "#{[0x16].pack('U*')}"
        },
    }
        
    SYM_FACES = {
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
    }
    
    SYM_SUITS = {
        :spade => {
            :unicode => "#{[0x2660].pack('U*')}",
            :name => "spade",
            :plain => "<3<",
            :color => :black,
            :abbrev => "S",
        },
        :heart => {
            :unicode => "#{[0x2661].pack('U*')}",
            :name => "heart",
            :plain => "<3",
            :color => :red,
            :abbrev => "H",
        },
        :diamond => {
            :unicode => "#{[0x2662].pack('U*')}",
            :name => "diamond",
            :plain => "<>",
            :color => :red,
            :abbrev => "D",
        },
        :club => {
            :unicode => "#{[0x2663].pack('U*')}",
            :name => "club",
            :plain => "c3<",
            :color => :black,
            :abbrev => "C",
        }
    }
    
    
    
    SYM_NUMBERS = {
        0 => {
            :name => "zero",
            :roman => "N",
        },
        1 => {
            :name => "one",
            :roman => "I",
        },
        2 => {
            :name => "two",
            :roman => "II",
        },
        3 => {
            :name => "three",
            :roman => "III",
        },
        4 => {
            :name => "four",
            :roman => "IV",
        },
        5 => {
            :name => "five",
            :roman => "V",
        },
        6 => {
            :name => "six",
            :roman => "VI",
        },
        7 => {
            :name => "seven",
            :roman => "VII",
        },
        8 => {
            :name => "eight",
            :roman => "VIII",
        },
        9 => {
            :name => "nine",
            :roman => "IX",
        },
        10 => {
            :name => "ten",
            :roman => "X",
        },
        11 => {
            :name => "eleven",
            :roman => "XI",
        },
        12 => {
            :name => "twelve",
            :roman => "XII",
        },
        13 => {
            :name => "thirteen",
            :roman => "XIII",
        },
        14 => {
            :name => "fourteen",
            :roman => "XIV",
        },
        15 => {
            :name => "fifteen",
            :roman => "XV",
        },
        16 => {
            :name => "sixteen",
            :roman => "XVI",
        },
        17 => {
            :name => "seventeen",
            :roman => "XVII",
        },
        18 => {
            :name => "eighteen",
            :roman => "XVIII",
        },
        19 => {
            :name => "nineteen",
            :roman => "XIX",
        },
        20 => {
            :name => "twenty",
            :roman => "XX",
        },
    }
    
    SYM_GREEKS = {
        :alpha => {
            :upper => "#{[0x0391].pack('U*')}",
            :lower => "#{[0x03B1].pack('U*')}",
            :name => "alpha",
            :value => 1,
            :type => :letter,
        },
        :beta => { 
            :upper => "#{[0x0392].pack('U*')}",
            :lower => "#{[0x03B2].pack('U*')}",
            :name => "beta",
            :value => 2,
            :type => :letter,
        },
        :gamma => {
            :upper => "#{[0x0393].pack('U*')}",
            :lower => "#{[0x03B3].pack('U*')}",
            :name => "gamma",
            :value => 3,
            :type => :letter,
        },
        :delta => {
            :upper => "#{[0x0394].pack('U*')}",
            :lower => "#{[0x03B4].pack('U*')}",
            :name => "delta",
            :value => 4,
            :type => :letter,
        },
        :epsilon => {
            :upper => "#{[0x0395].pack('U*')}",
            :lower => "#{[0x03B5].pack('U*')}",
            :name => "epsilon",
            :value => 5,
            :type => :letter,
        },
        :zeta => {
            :upper => "#{[0x0396].pack('U*')}",
            :lower => "#{[0x03B6].pack('U*')}",
            :name => "zeta",            
            :value => 7,
            :type => :letter,
        },
        :eta => {
            :upper => "#{[0x0397].pack('U*')}",
            :lower => "#{[0x03B7].pack('U*')}",
            :name => "eta",
            :value => 8,
            :type => :letter,
        },
        :theta => {
            :upper => "#{[0x0398].pack('U*')}",
            :lower => "#{[0x03B8].pack('U*')}",
            :name => "theta",
            :value => 9,
            :type => :letter,
        },
        :iota => {
            :upper => "#{[0x0399].pack('U*')}",
            :lower => "#{[0x03B9].pack('U*')}",
            :name => "iota",
            :value => 10,
            :type => :letter,
        },
        :kappa => {
            :upper => "#{[0x039A].pack('U*')}",
            :lower => "#{[0x03BA].pack('U*')}",
            :name => "kappa",
            :value => 20,
            :type => :letter,
        },
        :lambda => {
            :upper => "#{[0x039B].pack('U*')}",
            :lower => "#{[0x03BB].pack('U*')}",
            :name => "lambda",
            :value => 30,
            :type => :letter,
        },
        :mu => {
            :upper => "#{[0x039C].pack('U*')}",
            :lower => "#{[0x03BC].pack('U*')}",
            :name => "mu",
            :value => 40,
            :type => :letter,
        },
        :nu => {
            :upper => "#{[0x039D].pack('U*')}",
            :lower => "#{[0x03BD].pack('U*')}",
            :name => "nu",
            :value => 50,
            :type => :letter,
        },
        :xi => {
            :upper => "#{[0x039E].pack('U*')}",
            :lower => "#{[0x03BE].pack('U*')}",
            :name => "xi",
            :value => 60,
            :type => :letter,
        },
        :omicron => {
            :upper => "#{[0x039F].pack('U*')}",
            :lower => "#{[0x03BF].pack('U*')}",
            :name => "omicron",
            :value => 70,
            :type => :letter,
        },
        :pi => {
            :upper => "#{[0x03A0].pack('U*')}",
            :lower => "#{[0x03C0].pack('U*')}",
            :name => "pi",
            :value => 80,
            :type => :letter,
        },
        :rho => {
            :upper => "#{[0x03A1].pack('U*')}",
            :lower => "#{[0x03C1].pack('U*')}",
            :name => "rho",
            :value => 100,
            :type => :letter,
        },
        :sigma => {
            :upper => "#{[0x03A3].pack('U*')}",
            :lower => "#{[0x03C3].pack('U*')}",
            :name => "sigma",
            :value => 200,
            :type => :letter,
        },
        :tau => {
            :upper => "#{[0x03A4].pack('U*')}",
            :lower => "#{[0x03C4].pack('U*')}",
            :name => "tau",
            :value => 300,
            :type => :letter,
        },
        :upsilon => {
            :upper => "#{[0x03A5].pack('U*')}",
            :lower => "#{[0x03C5].pack('U*')}",
            :name => "upsilon",
            :value => 400,
            :type => :letter,
        },
        :phi => {
            :upper => "#{[0x03A6].pack('U*')}",
            :lower => "#{[0x03C6].pack('U*')}",
            :name => "phi",
            :value => 500,
            :type => :letter,
        },
        :chi => {
            :upper => "#{[0x03A7].pack('U*')}",
            :lower => "#{[0x03C7].pack('U*')}",
            :name => "chi",
            :value => 600,
            :type => :letter,
        },
        :psi => {
            :upper => "#{[0x03A8].pack('U*')}",
            :lower => "#{[0x03C8].pack('U*')}",
            :name =>	"psi",
            :value => 700,
            :type => :letter,
        },
        :omega => {
            :upper => "#{[0x03A9].pack('U*')}",
            :lower => "#{[0x03C9].pack('U*')}",
            :name => "omega",
            :value => 800,
            :type => :letter,
        },
        :stigma => {
            :upper => "#{[0x03DA].pack('U*')}",
            :lower => "#{[0x03DB].pack('U*')}",
            :name => "stigma",
            :value => 6,
            :type => :number,
        },
        :koppa => {
            :upper => "#{[0x03DE].pack('U*')}",
            :lower => "#{[0x03DF].pack('U*')}",
            :name => "koppa",
            :value => 90,
            :type => :number,
        },
        :sampi => {
            :upper => "#{[0x03E0].pack('U*')}",
            :lower => "#{[0x03E1].pack('U*')}",
            :name => "sampi",
            :value => 900,
            :type => :number,
        }
    }
    
    SYM_TAROT = {
        :suits => {},
        :major => {
            0 => {
                :name => "The Fool"    
            },
            1 => {
                :name => "The Magician"    
            },
            2 => {
                :name => "The High Priestess"    
            },
            3 => {
                :name => "The Empress"    
            },
            4 => {
                :name => "The Emperor"    
            },
            5 => {
                :name => "The Hierophant"    
            },
            6 => {
                :name => "The Lovers"    
            },
            7 => {
                :name => "The Chariot"    
            },
            8 => {
                :name => "Justice"    
            },
            9 => {
                :name => "The Hermit"    
            },
            10 => {
                :name => "Wheel of Fortune"    
            },
            11 => {
                :name => "Strenght"    
            },
            12 => {
                :name => "The Hanged Man"    
            },
            13 => {
                :name => "Death"    
            },
            14 => {
                :name => "Temperance"
            },
            15 => {
                :name => "The Devil"    
            },
            16 => {
                :name => "The Tower"    
            },
            17 => {
                :name => "The Star"    
            },
            18 => {
                :name => "The Moon"    
            },
            19 => {
                :name => "The Sun"    
            },
            20 => {
                :name => "The Judgement"    
            },
            21 => {
                :name => "The World"    
            },
        },
        :minor => {}
    }
    
    def self.test
        return SYM_GREEKS.collect{ |k,v| "#{v[:upper]}!" }
    end
    
end

# puts Symbols::test