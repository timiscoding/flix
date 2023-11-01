class GenresController < ApplicationController
  before_action :require_admin, except: %i[index show]

  def index
    @genres = Genre.all
    @genre = Genre.new
  end

  def show
    @genre = Genre.find(params[:id])
    @movies = @genre.movies
  end

  def create
    @genre = Genre.new(genre_params)
    @genres = Genre.all

    if @genre.save
      redirect_to genres_path, notice: 'Created genre'
    else
      flash.now[:alert] = 'Failed to create genre'
      render :index
    end
  end

  def update
    @genre = Genre.find(params[:id])
    @movies = @genre.movies


    if @genre.update(genre_params)
      redirect_to @genre, notice: 'Genre updated'
    else
      flash.now[:alert] = 'Genre update failed'
      render :show
    end
  end

  def destroy
    genre = Genre.find(params[:id])
    genre.destroy

    redirect_to genres_path, notice: 'Genre deleted'
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end
