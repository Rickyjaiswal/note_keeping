class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes or /notes.json
  def index
    share_notes = ShareNote.where(user_id: current_user).pluck(:note_id)
    @notes = (Note.where(user_id: current_user) + Note.where(id: share_notes)).uniq
  end

  def share
    parent_id = ShareNote.find_by(note_id: params[:note_id])
    shared = ShareNote.where(user_id: params[:share][:user_id],note_id: params[:note_id])
    if shared.present?
      redirect_to notes_url, notice: "Note was already shared."
    elsif (Note.find_by(user_id: params[:share][:user_id] ,id: params[:note_id])).present?
      redirect_to notes_url, notice: "Note was creted by me."
    elsif parent_id.present?
      ShareNote.create(user_id: params[:share][:user_id],note_id: params[:note_id], parent_id: parent_id.user_id)
      redirect_to notes_url, notice: "Note was successfully shared with parent."
    else
      ShareNote.create(user_id: params[:share][:user_id],note_id: params[:note_id])
      redirect_to notes_url, notice: "Note was successfully shared."
    end
  end

  def unshare
    shared = ShareNote.find_by(user_id: params[:share][:user_id],note_id: params[:note_id],parent_id: nil)
    parent_share = ShareNote.where(parent_id: shared.user_id)
    if shared.present?
      shared.destroy
      parent_share.delete_all
      redirect_to notes_url, notice: "Note was successfully removed from shared."
    end
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.new(note_params)
    @note.update(:user_id=>current_user.id)
    respond_to do |format|
      if @note.save
        format.html { redirect_to note_url(@note), notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:note)
    end
end
