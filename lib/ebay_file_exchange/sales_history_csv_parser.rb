# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'iconv'

class SalesHistoryCSVParser

  attr_reader :csv_file

  def initialize(csv_file:, ebay_site_id: 3)
    raise 'Can only parse CSV files from UK  [3]' unless ebay_site_id == 3
    raise "File '#{csv_file}' does not exist" if !File.exist?(csv_file)
    @csv_file = File.new csv_file

    parse
  end

  def to_s
    "Sales History: '#{csv_file.path}'"
  end

  #---------------------------------------------------------------------------
  private

  def parse
    read_lines
    read_column_names
    puts @columns.join("\n")
  end

  def read_lines
    @csv_lines = []
    begin
      csv_file.each_line do |line|
        line = Iconv.conv('UTF-8', 'ISO-8859-1', line).strip # Ensure the line is in UTF-8
        next if (line.blank?)

        # Put double quotes into any seemingly unquoted fields.
        # Unquoted fields will contain ",,"
        line = line.gsub(/,,/, ',"",')
        @csv_lines.push(line)
      end
    rescue Iconv::IllegalSequence => exception
      raise "Failed to convert character encoding from 'ISO-8859-1'\n#{exception.message}"
    rescue Exception => exception
      raise exception
    ensure
      csv_file.close if csv_file
    end
    @csv_lines
  end


  # Read the names of all the columns in the CSV data as an array of symbols.
  # This should be the first non-blank line in the file.
  #
  def read_column_names
    @columns = @csv_lines[0].split(/[\s]*,[\s]*/)
    @columns.map! { |c| c.downcase.gsub(/[^a-z 0-9]+/i, ' ').strip.gsub(/[ ]+/, '_').to_sym }

    required = [
        :sales_record_number,
        :user_id,
        :buyer_full_name,
        :buyer_phone_number,
        :buyer_email,
        :buyer_address_1,
        :buyer_address_2,
        :buyer_town_city,
        :buyer_county,
        :buyer_postcode,
        :buyer_country,
        :item_number,
        :item_title,
        :custom_label,
        :quantity,
        :sale_price,
        :included_vat_rate,
        :postage_and_packaging,
        :insurance,
        :cash_on_delivery_fee,
        :total_price,
        :payment_method,
        :sale_date,
        :checkout_date,
        :paid_on_date,
        :dispatch_date,
        :invoice_date,
        :invoice_number,
        :feedback_left,
        :feedback_received,
        :notes_to_yourself,
        :paypal_transaction_id,
        :delivery_service,
        :cash_on_delivery_option,
        :transaction_id,
        :order_id,
        :variation_details,
        :global_shipping_programme,
        :global_shipping_reference_id,
        :click_and_collect,
        :click_and_collect_reference,
        :post_to_address_1,
        :post_to_address_2,
        :post_to_city,
        :post_to_county,
        :post_to_postcode,
        :post_to_country,
        :ebay_plus
    ]
    required.each { |c| raise "Column #{c} not found" unless @columns.include?(c) }
  end

end
