package com.example.mypgrapp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class OrganizationAdapter(private val organizations: List<Organization>) : RecyclerView.Adapter<OrganizationAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val imageView: ImageView = view.findViewById(R.id.organization_image)
        val nameTextView: TextView = view.findViewById(R.id.organization_name)
        val descriptionTextView: TextView = view.findViewById(R.id.organization_description)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.organization_list_item, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val organization = organizations[position]
        holder.nameTextView.text = organization.name
        holder.descriptionTextView.text = getLocalizedDescription(organization.description)
        val context = holder.imageView.context
        val resourceId = context.resources.getIdentifier(organization.image, "drawable", context.packageName)
        holder.imageView.setImageResource(resourceId)
    }

    private fun getLocalizedDescription(descriptions: Map<String, String>): String {
        val preferredLanguage = java.util.Locale.getDefault().language
        return descriptions[preferredLanguage] ?: descriptions["en"] ?: ""
    }

    override fun getItemCount() = organizations.size
}
