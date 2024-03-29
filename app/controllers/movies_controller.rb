class MoviesController < ApplicationController

  helper_method :sort_column, :sort_direction

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if !session[:sort] and !session[:ratings] and !params[:sort] and !params[:ratings]
      session[:sort] = ''
      session[:ratings] = []
    elsif params[:sort] or params[:ratings]
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings]
    else
      redirect_to movies_path( :sort => session[:sort], :ratings => session[:ratings] )
    end

    # TODO: refactor
    # ugly ugly, refactor

    if params[:ratings]
      unless sort_column.empty?
        @movies = Movie.where(:rating => params[:ratings].keys).order(sort_column + " " + sort_direction)
      else
        @movies = Movie.where(:rating => params[:ratings].keys)
      end
    else

      unless sort_column.empty?
        @movies = Movie.order(sort_column + " " + sort_direction)
      else
        @movies = Movie.all
      end

    end
    @selected_ratings = (params[:ratings].present? ? params[:ratings] : Movie.all_ratings)
    @all_ratings = Movie.all_ratings

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."

    #redirect_to movies_path(:rating => session[:rating], :direction => session[:direction], :sort => session[:sort])
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : ""
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
