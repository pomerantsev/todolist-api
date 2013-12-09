class TodosController < ApplicationController
  before_action :authenticate_user_from_token!
  def index
    @todos = Todo.all.order(id: :asc)

    render json: @todos
  end

  def show
    @todo = Todo.find_by(id: params[:id])

    if @todo
      render json: @todo
    else
      head :not_found
    end
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    @todo = Todo.find_by(id: params[:id])

    if @todo
      if @todo.update(todo_params)
        head :no_content
      else
        render json: @todo.errors, status: :unprocessable_entity
      end
    else
      head :not_found
    end
  end

  def destroy
    @todo = Todo.find_by(id: params[:id])
    if @todo
      @todo.destroy
      head :no_content
    else
      head :not_found
    end
  end

private

  def todo_params
    params.permit(:title, :completed, :due_date, :priority)
  end
end
