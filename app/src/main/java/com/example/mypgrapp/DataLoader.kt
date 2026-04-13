package com.example.mypgrapp

import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class DataLoader(private val context: Context) {

    fun loadGameData(): GameData? {
        return try {
            val jsonString = context.assets.open("GameData.json").bufferedReader().use { it.readText() }
            val gson = Gson()
            val gameDataType = object : TypeToken<GameData>() {}.type
            gson.fromJson(jsonString, gameDataType)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}
