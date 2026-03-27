package com.example.mypgrapp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class CharacterAdapter(private val characters: List<Character>) : RecyclerView.Adapter<CharacterAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val imageView: ImageView = view.findViewById(R.id.character_image)
        val nameTextView: TextView = view.findViewById(R.id.character_name)
        val descriptionTextView: TextView = view.findViewById(R.id.character_description)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.character_list_item, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val character = characters[position]
        holder.nameTextView.text = character.name
        holder.descriptionTextView.text = getLocalizedDescription(character.description)
        val context = holder.imageView.context
        val resourceId = context.resources.getIdentifier(character.image, "drawable", context.packageName)
        holder.imageView.setImageResource(resourceId)
    }

    private fun getLocalizedDescription(descriptions: Map<String, String>): String {
        val preferredLanguage = java.util.Locale.getDefault().language
        return descriptions[preferredLanguage] ?: descriptions["en"] ?: ""
    }

    override fun getItemCount() = characters.size
}
