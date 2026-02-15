package com.example.auth.controller;

import org.springframework.web.bind.annotation.*;
import com.example.auth.model.User;
import com.example.auth.service.UserService;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:3000")
public class AuthController {

    private final UserService service;

    public AuthController(UserService service) {
        this.service = service;
    }

    @PostMapping("/register")
    public User register(@RequestBody User user) {
        System.out.println("EMAIL: " + user.getEmail());
        System.out.println("PASSWORD: " + user.getPassword());
        return service.register(user);
    }

    @PostMapping("/login")
    public User login(@RequestBody User user) {
        return service.login(user.getEmail(), user.getPassword());
    }
}


