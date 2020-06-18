defmodule TodoWeb.TodolistView do
  use TodoWeb, :view
  alias TodoWeb.TodolistView

  def render("index.json", %{todolists: todolists}) do
    %{data: render_many(todolists, TodolistView, "todolist.json")}
  end

  def render("show.json", %{todolist: todolist}) do
    %{data: render_one(todolist, TodolistView, "todolist.json")}
  end

  def render("todolist.json", %{todolist: todolist}) do
    %{id: todolist.id,
      event_date: todolist.event_date,
      title: todolist.title,
      description: Map.get(todolist, :description, nil)
      }
  end
end
