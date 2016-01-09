#
# Helpers mix-ins for executable files found in /exe
#

require 'optparse' # OptionParser is a class for command-line option analysis
require 'optparse/time'
require 'ostruct'  # An OpenStruct is a data structure, similar to a Hash

# http://stackoverflow.com/questions/1489183/colorized-ruby-output
class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\0330m"  end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end

module ExecutableHelper

  # Get a generic auth_token that can be used with user independent
  # calls, such as GetCategories.
  #
  # @return [String] the authentication token for a valid eBay user.
  #
  def generic_auth_token
    username = ENV['EBAY_API_USERNAME_TT']
    EbayTrader.configuration.auth_token_for(username)
  end

  #
  # Get an OpenStruct (similar to a hash) used to store command line options.
  # @return [OpenStruct] of options
  #
  def options
    unless defined? @command_line_options
      @command_line_options = OpenStruct.new
      #@command_line_options.ebay_site_id = DEFAULT_EBAY_SITE_ID
    end
    @command_line_options
  end

  #
  # Render the given string to the console in the specified colour.
  # @param string [String] the string to be displayed on the console
  # @param color [Symbol] :red, :green or :brown
  # @param line_end [String] the line end terminator.
  # @return [nil] nothing is returned.
  #
  def console(string, color = nil, line_end = "\n")
    if String.public_method_defined?(:red)
      case color
        when :red then
          print string.red
        when :green then
          print string.green
        when :brown then
          print string.brown
        else
          print string
      end
    else
      print string
    end
    print line_end
    nil
  end
end
