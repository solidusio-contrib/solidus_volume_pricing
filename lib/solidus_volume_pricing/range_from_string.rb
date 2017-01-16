module SolidusVolumePricing
  class RangeFromString
    attr_reader :range_string

    RANGE_FORMAT = /\A\(?(\d+)(\.{2,3})(\d+)\)?\z/.freeze
    OPEN_ENDED = /\(?[0-9]+\+\)?/.freeze

    def initialize(range_string)
      @range_string = range_string
    end

    def to_range
      ::Range.new(*options_from_string)
    end

    private

    def options_from_string
      case range_string
      when OPEN_ENDED
        [range_string.tr("^0-9", '').to_i, Float::INFINITY]
      when RANGE_FORMAT
        [
          Regexp.last_match[1].to_i,
          Regexp.last_match[3].to_i,
          Regexp.last_match[2].length == 3
        ]
      else
        raise ArgumentError,
          I18n.t(:could_not_convert_to_range, scope: 'activerecord.errors.messages', string: range_string)
      end
    end
  end
end
