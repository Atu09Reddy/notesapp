package com.example.notesapp;

import com.example.notesapp.Note;
import com.example.notesapp.NoteRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class NoteController {

    private final NoteRepository noteRepository;

    public NoteController(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("notes", noteRepository.findAll());
        model.addAttribute("note", new Note());
        return "index";
    }

    @PostMapping("/notes")
    public String addNote(@ModelAttribute Note note) {
        noteRepository.save(note);
        return "redirect:/";
    }

    @GetMapping("/notes/delete/{id}")
    public String deleteNote(@PathVariable Long id) {
        noteRepository.deleteById(id);
        return "redirect:/";
    }
}
