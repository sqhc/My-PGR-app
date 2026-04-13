package com.example.mypgrapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class OrganizationsActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_organizations)

        val recyclerView = findViewById<RecyclerView>(R.id.organizations_recycler_view)
        recyclerView.layoutManager = LinearLayoutManager(this)

        val dataLoader = DataLoader(this)
        val gameData = dataLoader.loadGameData()
        if (gameData != null) {
            recyclerView.adapter = OrganizationAdapter(gameData.organizations)
        }
}
