class TodosController < ApplicationController
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
    @todo = Todo.new(params[:todo])

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    @todo = Todo.find(params[:id])

    if @todo.update(params[:todo])
      head :no_content
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy

    head :no_content
  end
end
