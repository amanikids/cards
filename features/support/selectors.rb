module SelectorHelpers
  def actual_address
    tableish('.address div', 'span')
  end

  def actual_cart
    tableish('table.cart tbody tr', 'td')
  end

  def actual_inventory
    tableish('table#products tbody tr', 'td')
  end
end

World(SelectorHelpers)
