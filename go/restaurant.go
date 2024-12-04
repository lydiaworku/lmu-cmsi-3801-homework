package main

import (
	"log"
	"math/rand"
	"time"
	"sync"
	"sync/atomic"
)

// A little utility that simulates performing a task for a random duration.
// For example, calling do(10, "Remy", "is cooking") will compute a random
// number of milliseconds between 5000 and 10000, log "Remy is cooking",
// and sleep the current goroutine for that much time.

func do(seconds int, action ...any) {
    log.Println(action...)
    randomMillis := 500 * seconds + rand.Intn(500 * seconds)
    time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

type Order struct {
	id uint64
	customer string
	reply chan *Order
	cook string
}

// mechanism to generate the next order id
var nextId atomic.Uint64

// a waiter can only hold 3 orders at once
var Waiter = make(chan *Order, 3)

func Cook(name string) {
	log.Println(name, "is starting")
	for {
		order := <-Waiter
		do(5, name, "is cooking order", order.id)
		order.cook = name
		order.reply <- order
	}
}

func Customer(name string, wg *sync.WaitGroup) {
	defer wg.Done()
	for mealsEaten := 0; mealsEaten < 5; {
		order := &Order{
			id: nextId.Add(1),
			customer: name, 
			reply: make(chan *Order, 1),
		}

		select {
		case Waiter <- order:
			select {
			case cookedOrder := <-order.reply:
				mealsEaten++
				do(10, name, "is eating meal from", cookedOrder.cook, "order", cookedOrder.id)
			case <-time.After(7 * time.Second):
				do(5, name, "is waiting too long, abandoning the order", order.id)
			}
		case <-time.After(7 * time.Second):
			do(5, name, "could not place order, leaving the restaurant")
			return
		}
	}
}

func main() {
	rand.Seed(time.Now().UnixNano())

	customers := []string{
		"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
	}

	// in a loop start each customer as a goroutine
	var wg sync.WaitGroup
	for _, customer := range customers {
		wg.Add(1)
		go Customer(customer, &wg)
	}

	go Cook("Remy")
	go Cook("Linguini")
	go Cook("Colette")

	wg.Wait()
	log.Println("restaurant closing")

}