module Milight
  module Command
    SET_COLOR = '40'

    LED_ON = {
      all: '42',
      group1: '45',
      group2: '47',
      group3: '49',
      group4: '4B',
    }

    LED_OFF = {
      all: '41',
      group1: '46',
      group2: '48',
      group3: '4A',
      group4: '4C',
    }

    DISCO_SPEED_SLOWER = '43'
    DISCO_SPEED_FASTER = '44'
    DISCO_MODE = '4D'
    DISCO_MODE_NEXT = '27'
    DISCO_MODE_PREVIOUS = '28'

    #TODO: not RGB?
    WARM_WHITE_INCREASE = '3E'
    COOL_WHITE_INCREASE = '3F'

    BRIGHTENESS = '4E'

    NIGHT = {
      all: 'C1',
      group1: 'C6',
      group2: 'C8',
      group3: 'CA',
      group4: 'CC',
    }

    WHITE = {
      all: 'C2',
      group1: 'C5',
      group2: 'C7',
      group3: 'C9',
      group4: 'CB',
    }
  end
end
