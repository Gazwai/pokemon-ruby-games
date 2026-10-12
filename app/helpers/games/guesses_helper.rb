module Games::GuessesHelper
  TYPE_COLORS = {
    "normal" => "bg-[#a8a77a] text-neutral",
    "fire" => "bg-[#ee8130] text-neutral",
    "water" => "bg-[#6390f0] text-neutral",
    "electric" => "bg-[#f7d02c] text-neutral",
    "grass" => "bg-[#7ac74c] text-neutral",
    "ice" => "bg-[#96d9d6] text-neutral",
    "fighting" => "bg-[#c22e28] text-white",
    "poison" => "bg-[#a33ea1] text-white",
    "ground" => "bg-[#e2bf65] text-neutral",
    "flying" => "bg-[#a98ff3] text-neutral",
    "psychic" => "bg-[#f95587] text-neutral",
    "bug" => "bg-[#a6b91a] text-neutral",
    "rock" => "bg-[#b6a136] text-neutral",
    "ghost" => "bg-[#735797] text-white",
    "dragon" => "bg-[#6f35fc] text-white",
    "dark" => "bg-[#705746] text-white",
    "steel" => "bg-[#b7b7ce] text-neutral",
    "fairy" => "bg-[#d685ad] text-neutral"
  }.freeze

  def type_badge(type)
    tag.span type, class: [ "badge border-0 font-bold uppercase tracking-wide", TYPE_COLORS.fetch(type, "badge-neutral") ]
  end
end
