class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = current_user.notes.order(updated_at: :desc).search(params[:search]).page(params[:page])
  end

  def show
    @comment = @note.comments.new
    @comments = @note.comments.order(id: :desc)
    @likes = @note.likes.count
  end

  def new
    @note = current_user.notes.new
    @note.save
    redirect_to "/notes/#{@note.id}"
  end

  def edit
  end

  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: {status: "error", message: "Save error"}
    end
  end

  def destroy
    if @note.destroy
      redirect_to "/notes"
    end
  end



  private 
  def note_params
    params.require(:note).permit(:title, :content, :tag_list)
  end

  def find_user_note
    @note = current_user.notes.find(params[:id])
  end
end
