defmodule Mechanizex.Form.Option do
  alias Mechanizex.Page.{Element, Elementable}

  @derive [Elementable]
  @enforce_keys [:element, :index]
  defstruct element: nil, label: nil, value: nil, selected: false, index: nil

  @type t :: %__MODULE__{
          element: Element.t(),
          label: String.t(),
          value: String.t(),
          index: integer(),
          selected: boolean()
        }

  def new({%Element{} = el, index}) do
    %__MODULE__{
      element: el,
      value: Element.attr(el, :value) || Element.text(el),
      label: Element.attr(el, :label) || Element.text(el),
      index: index,
      selected: Element.attr_present?(el, :selected)
    }
  end
end

defimpl Mechanizex.Queryable, for: Mechanizex.Form.Option do
  alias Mechanizex.Queryable.Defaults

  defdelegate name(queryable), to: Defaults
  defdelegate text(queryable), to: Defaults

  def attrs(queryable) do
    queryable
    |> Defaults.attrs()
    |> List.keystore("label", 0, {"label", queryable.label})
    |> List.keystore("value", 0, {"value", queryable.value})
    |> List.keystore("selected", 0, {"selected", queryable.selected})
    |> List.keystore("index", 0, {"index", queryable.index})
  end
end