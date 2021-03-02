# app/controllers/api/v1/restaurants_controller.rb
class Api::V1::RestaurantsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :find_restaurant, only: [ :show, :update, :destroy ]

  def index
    @restaurants = policy_scope(Restaurant)
  end

  def show
  end

  def update
    if @restaurant.update(strong_params)
      render :show
    else
      render_error
    end
  end

  def create
    @restaurant =  Restaurant.new(strong_params)
    @restaurant.user = current_user
    authorize @restaurant
    if @restaurant.save
      render :show, status: :created
    else
      render_error
    end
  end

  def destroy
    @restaurant.destroy
    head :no_content
    # render json: { message: 'Restaurant has been deleted'}
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def strong_params
    params.require(:restaurant).permit(:name, :address)
  end

  def render_error
    render json: { errors: @restaurant.errors.full_messages },
      status: :unprocessable_entity
  end

end
