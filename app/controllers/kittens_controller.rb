class KittensController < ApplicationController
  def index
    @kittens = Kitten.all
    respond_to do |format|
      format.html
      format.json { render json: @kittens }
    end

    p key = ENV['FLICKR_API_KEY'] 
    p secret = ENV['FLICKR_SHARED_SECRET']
    flickr = Flickr.new(key, secret)

    info = flickr.photos.getInfo(:photo_id => "3839885270")
    @photo = Flickr.url_b(info)
  end

  def show
    @kitten = Kitten.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @kitten }
    end
  end

  def new
    @kitten = Kitten.new
  end

  def edit
    @kitten = Kitten.find(params[:id])
  end

  def create
    @kitten = Kitten.new(kitten_params)

    if @kitten.save
      redirect_to @kitten, notice: 'Kitten was successfully created.'
    else
      render 'new', alert: 'Kitten was not created.'
    end
  end

  def update
    @kitten = Kitten.find(params[:id])

    if @kitten.update(kitten_params)
      redirect_to @kitten, notice: 'Kitten was successfully updated.'
    else
      render 'edit', alert: 'Kitten was not updated.'
    end
  end

  def destroy
    @kitten = Kitten.find(params[:id])
    @kitten.destroy

    redirect_to kittens_path, notice: 'Kitten was successfully destroyed.'
  end

  private

  def kitten_params
    params.require(:kitten).permit(:name, :age, :cuteness, :softness)
  end
end
