class UploadController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def create
    params.require(:database)
    @total_revenue = 0
    begin
      normalize
    rescue => ex
      logger.info "Exception #{ex}"
      ex
      @error = "#{ex}"
    end
  end


private

  def normalize
    @counter = 1
    infile = params['database'].read
    infile.each_line do |line|
      if @counter != 1 # skip header
        # row header is structured as follows: customer name, item description, item price,  quantity, merchant address, merchant name
        row = line.split("\t")
        # customer
        purchaser = customer(row)
        purchaser.save
        # merchant
        merchant = merchant(row)
        merchant.address = clean_data(row[4])
        merchant.save
        # item 
        line_item = item(row)
        line_item.price = clean_data(row[2])
        line_item.save
        # purchase
        purchase = Purchase.create(quantity: clean_data(row[3]), line_item_id: line_item.id, customer_id: purchaser.id)
        @total_revenue = @total_revenue + (purchase.quantity * line_item.price)
      end
      @counter = @counter + 1
    end
  end

  def customer(row)
    Customer.where(name: clean_data(row[0])).first_or_initialize
  end

  def merchant(row)
    Merchant.where(name: clean_data(row[5])).first_or_initialize
  end

  def item(row)
    LineItem.where(description: clean_data(row[1])).first_or_initialize
  end

  # convert to string and strip white space
  def clean_data(r)
    r.to_s.strip
  end
end
