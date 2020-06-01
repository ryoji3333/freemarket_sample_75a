class ItemsController < ApplicationController
  before_action :set_item, except: [:index, :new, :create, :get_category_children, :get_category_grandchildren]
  before_action :check_login_user, except: [:index,:show, :new, :create]
  def index
  end

  def new
    @item = Item.new
    @images = @item.images.new
    @user = current_user
    @address = addressArrey(@user.user_address)
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
  end

  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end
  
  def create
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
    @item = Item.create(items_params)
    if @item.save
      flash[:success] = "出品しました"
      redirect_to root_path
    else
      flash.now[:alert] = "内容を確認してください"
      @images = @item.images.build
      render new_item_path
    end
  end
  
  def show
    @categories = Category.find(@items.category_id)
    @categories2 = @categories.parent
  end
  
  def edit
    @user = @item.user
    @address = addressArrey(@user.user_address)
    @images = @item.images
    @category_grandchildren = Category.find(@item[:category_id])
    @category_children = @category_grandchildren.parent
    @category_parent_array = ["#{@category_children.parent.name}"]
    Category.where(ancestry: nil).each_with_index do |parent, index|
      index += 1
      @category_parent_array << parent.name
      if index == 13
        break
      end
    end
  end
  
  def update
    @user = @item.user
    @category_grandchildren = Category.find(@item[:category_id])
    @category_children = @category_grandchildren.parent
    @category_parent_array = ["#{@category_children.parent.name}"]
    Category.where(ancestry: nil).each_with_index do |parent, index|
      index += 1
      @category_parent_array << parent.name
      if index == 13
        break
      end
    end
    if @item.update(items_params)
      flash[:success] = "内容を更新しました"
      redirect_to root_path
    else
      flash.now[:alert] = "編集内容を確認してください"
      render :edit
    end
  end

  def destroy
    @item.destroy
    flash[:alert] = "出品を取り消しました"
    redirect_to root_path
  end

  def purchase
  end

  private
    def items_params
      params.require(:item).permit(:item_name, :explanation, :price, :brand_id, :condition_id, :ship_date_id, :delivery_fee_id,:category_id,images_attributes: [:image,:_destroy, :id]).merge(user_id: current_user.id )
    end

    def set_item
      @item = Item.find(params[:id])
    end

    def check_login_user
      unless @user == @current_user
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_path
      end
    end

    def addressArrey(user_address)
      user_address_arrey = ["〒" +user_address.post + " ",user_address.preficture,user_address.city]
      return user_address_arrey.join
    end

end
