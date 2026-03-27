package com.example.mypgrapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class CharactersActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_characters)

        val recyclerView = findViewById<RecyclerView>(R.id.characters_recycler_view)
        recyclerView.layoutManager = LinearLayoutManager(this)

        val dataLoader = DataLoader(this)
        val gameData = dataLoader.loadGameData()
        if (gameData != null) {
            recyclerView.adapter = CharacterAdapter(gameData.characters)
        }
}
