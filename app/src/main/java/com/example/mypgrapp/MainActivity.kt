package com.example.mypgrapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val charactersButton = findViewById<Button>(R.id.characters_button)
        charactersButton.setOnClickListener {
            val intent = Intent(this, CharactersActivity::class.java)
            startActivity(intent)
        }

        val organizationsButton = findViewById<Button>(R.id.organizations_button)
        organizationsButton.setOnClickListener {
            val intent = Intent(this, OrganizationsActivity::class.java)
            startActivity(intent)
        }
    }
}
