class Admin::PurchaseOrdersController < ApplicationController
  # Admin layout
  layout "admin/application"
  # End Admin layout

  # Find purchase order with Friendly_ID
  before_action :set_purchase_order, only: [:show, :edit, :update, :active, :deactive, :history]
  # End Find purchase order with Friendly_ID

  # Sync model DSL
  enable_sync only: [:create, :update, :active, :deactive]
  # End Sync model DSL

  # Authentication
  # before_action :require_employee
  # End Authentication

  def new

  end

  def index
    @orders = Purchase.search_order(params[:search], params[:show]).paginate(page: params[:page], per_page: 15) # Orders with pagination
    @show_all = params[:show] == "all" ? true : false # View All (Enabled and Disabled)
    @count = @orders.count

    # PDF view configuration
    current_lang = params[:lang]
    I18n.locale = current_lang

    datetime =  Time.zone.now
    file_time = datetime.strftime("%m%d%Y")

    name_pdf = "purchase-orders-#{file_time}"
    template = "admin/purchase-order/index_pdf.html.haml"
    title_pdf = t("header.navigation.purchase-order")
    # End PDF view configuration

    respond_to do |format|
      format.html
      format.js
      format.pdf do
        to_pdf(name_pdf, template, Provider.all, I18n.l(datetime), title_pdf)
      end
    end
  end
end