require_relative '../settings'

# Choose a single-line daily quote from one of the quote files specified by the current Settings.
class DailyQuote

  def initialize line
    @line = line
  end

  def to_s
    @line
  end

  def self.choose
    @quotes = Settings.current.qotd_paths.map do |qpath|
      File.readable?(qpath) ? File.read(qpath).lines.to_a : []
    end.flatten

    new(@quotes[rand(@quotes.size)])
  end

end
