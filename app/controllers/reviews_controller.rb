class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_path(@movie), notice: 'Thanks for your review!'
    else
      render :new
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to movie_reviews_path(@movie), notice: 'Review deleted!'
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to movie_reviews_path(@movie), notice: 'Review updated!'
    else
      render :edit
    end
  end

  private

  def review_params
    params.require(:review).permit(:stars, :comment)
  end
  
  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
