package com.example.mypgrapp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import android.content.Context

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
        val context = holder.itemView.context
        holder.nameTextView.text = character.name
        holder.descriptionTextView.text = getLocalizedDescription(character.description, context)
        val resourceId = context.resources.getIdentifier(character.image, "drawable", context.packageName)
        holder.imageView.setImageResource(resourceId)
    }

    private fun getLocalizedDescription(descriptions: Map<String, String>, context: android.content.Context): String {
        val sharedPreferences = context.getSharedPreferences("My-PGR-app", android.content.Context.MODE_PRIVATE)
        val preferredLanguage = sharedPreferences.getString("selectedLanguage", null) ?: java.util.Locale.getDefault().language
        return descriptions[preferredLanguage] ?: descriptions["en"] ?: ""
    }

    override fun getItemCount() = characters.size
}
