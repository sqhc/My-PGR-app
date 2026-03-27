package com.example.mypgrapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AlertDialog
import android.content.Context

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

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.main_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.action_settings -> {
                showLanguageDialog()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun showLanguageDialog() {
        val languages = arrayOf("English", "Chinese")
        val builder = AlertDialog.Builder(this)
        builder.setTitle("Select Language")
        builder.setItems(languages) { _, which ->
            val languageCode = when (which) {
                0 -> "en"
                1 -> "zh"
                else -> "en"
            }
            setLanguage(languageCode)
        }
        builder.show()
    }

    private fun setLanguage(languageCode: String) {
        val sharedPreferences = getSharedPreferences("My-PGR-app", Context.MODE_PRIVATE)
        sharedPreferences.edit().putString("selectedLanguage", languageCode).apply()
        recreate()
    }
}
