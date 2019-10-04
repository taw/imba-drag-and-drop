# Browser APIs for drag and drop are awful so using this instead
let currentdrag = {}

tag Item
  def ondragstart(e)
    # Firefox workaround:
    e.event:data-transfer.set-data('text/plain', '')
    currentdrag = {data: data, source: self}

  def render
    <self draggable=true>
      data

tag Container
  # Get initial values from props
  def setup
    @items = data

  def onremove(e, payload)
    let idx = @items.indexOf(payload:data)
    @items.splice(idx, 1)

  def ondragenter(e)
    e.prevent()

  def ondragover(e)
    e.prevent()

  def ondrop(e)
    # Remove from previous container
    currentdrag:source.trigger('remove', {data: currentdrag:data})
    # Add to current container
    @items.push currentdrag:data

  def render
    <self>
      for item in @items
        <Item[item]>

tag App
  def ondragend(e)
    currentdrag = {}

  def render
    <self>
      <header>
        "Drag and Drop"
      <Container[["A", "B", "C"]]>
      <Container[["D", "E", "F"]]>

Imba.mount <App>
