class MoviesController < ApplicationController
  before_action :set_movie, only: %i(show edit update destroy)
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    case params[:filter]
      when 'upcoming'
        @movies = Movie.upcoming
      when 'recent'
        @movies = Movie.recent
      when 'hits'
        @movies = Movie.hits
      when 'flops'
        @movies = Movie.flops
      else
        @movies = Movie.released
    end
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie), notice: 'Movie successfully updated!'
    else
      render :edit
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to @movie, notice: 'Movie successfully created!'
    else
      render :new
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, alert: 'Movie successfully deleted!'
  end

  private

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :total_gross, :description, :rating, :released_on, :duration, :main_image, :director, genre_ids: [])
  end
end