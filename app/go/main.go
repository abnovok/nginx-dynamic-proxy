package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

type Response struct {
	Status             string              `json:"status"`
	Backend            string              `json:"backend"`
	PerceivedRemoteAddr string             `json:"perceived_remote_addr"`
	AllReceivedHeaders  map[string][]string `json:"all_received_headers"`
}

func logHeadersHandler(w http.ResponseWriter, r *http.Request) {
	// Собираем заголовки
	headers := make(map[string][]string)
	for k, v := range r.Header {
		headers[k] = v
	}

	// Логируем в stdout
	log.Printf("🐹 [Go App] Request from %s | XFF: %v", r.RemoteAddr, r.Header.Get("X-Forwarded-For"))

	resp := Response{
		Status:             "success",
		Backend:            "Go / Native HTTP",
		PerceivedRemoteAddr: r.RemoteAddr,
		AllReceivedHeaders:  headers,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(resp)
}

func main() {
	// Настраиваем стандартный логгер на вывод в stdout
	log.SetOutput(os.Stdout)
	log.Println("🚀 Starting Go backend on :8080...")

	// Обрабатываем любой URL (аналог catch-all)
	http.HandleFunc("/", logHeadersHandler)

	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Server failed: %s", err)
	}
}