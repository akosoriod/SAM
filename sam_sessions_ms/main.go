package main

import (
	"log"
	"net/http"

	"arquitectura/sam_sessions_ms/database"
	"arquitectura/sam_sessions_ms/models"
	"arquitectura/sam_sessions_ms/sessions"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm"
	"github.com/julienschmidt/httprouter"
)

func main() {

	router := httprouter.New()
	router.GET("/token/:username", sessions.GetSessionToken)
	router.GET("/validate", sessions.ValidateToken)
	router.GET("/refresh", sessions.RefreshToken)
	router.DELETE("/Revoke", sessions.RevokeToken)
	router.DELETE("/Revoke/:username", sessions.RevokeAllTokens)
	initDb()
	log.Fatal(http.ListenAndServe("0.0.0.0:3005", router))
}

func initDb() {
	var err error
	database.DB, err = gorm.Open("mysql", "arqsoft:123@tcp(192.168.99.102:8814)/sessions?charset=utf8&parseTime=True&loc=Local")
	//database.DB, err = gorm.Open("mysql", "root:root@tcp(localhost:3306)/sam_session_db?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		log.Println(err)
	}
	if !database.DB.HasTable(&models.RefreshToken{}) {
		database.DB.CreateTable(&models.RefreshToken{})
		database.DB.AutoMigrate(&models.RefreshToken{})
	}

}
