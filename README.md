# SecureWindowsToolkit
Projekt Marcela to zestaw skryptów i porad dla użytkowników Windows, którzy chcą zwiększyć bezpieczeństwo, prywatność i kontrolę nad systemem. Idealny dla uczniów, entuzjastów optymalizacji i każdego, kto ceni czysty, sprawny komputer.
jak uruchomić skrypt?  Jak uruchomić skrypt  Jak uruchomić skrypt czyszczenie_systemu.ps1
- Pobierz plik skryptu z repozytorium lub skopiuj jego zawartość do nowego pliku .ps1
- Kliknij prawym przyciskiem myszy na plik → wybierz „Uruchom jako administrator”
- Zatwierdź uruchomienie, jeśli pojawi się ostrzeżenie systemowe
- Po zakończeniu działania skryptu, sprawdź log czyszczenia zapisany na pulpicie (log_czyszczenia.txt)
  Skrypt usuwa tylko pliki tymczasowe, zawartość kosza i folderu Prefetch — nie rusza żadnych danych użytkownika.

  
Wymagania Systemowe
SecureWindowsToolkit to narzędzie stworzone dla świadomych użytkowników, którzy cenią sobie bezpieczeństwo i nowoczesną architekturę systemu. Z tego powodu, zanim uruchomisz ten program, upewnij się, że Twój komputer jest odpowiednio skonfigurowany.
Nasz wbudowany skrypt startowy (Start-SecureToolkit.ps1) automatycznie zweryfikuje, czy Twój system spełnia poniższe, obowiązkowe wymagania. Jeśli którekolwiek z nich nie zostanie spełnione, program nie uruchomi się i wyświetli odpowiedni komunikat.
Minimalne Wymagania Sprzętowe i Konfiguracyjne:
System Operacyjny:
Windows 11 (zalecany) lub Windows 10
Architektura 64-bit
Konfiguracja BIOS/UEFI (Kluczowe Wymagania):
Tryb systemu BIOS: UEFI
Starszy tryb "Legacy" nie jest wspierany.
Moduł TPM 2.0: Włączony i gotowy do użycia
Możesz to sprawdzić, wpisując tpm.msc w menu Start.
Bezpieczny Rozruch (Secure Boot): Włączony
Możesz to sprawdzić, uruchamiając msinfo32 (Informacje o systemie).
Wirtualizacja Procesora (Intel VT-x / AMD-V): Włączona
Jest to konieczne do działania Zabezpieczeń opartych na wirtualizacji.
Konfiguracja Systemu Windows:
Zabezpieczenia oparte na wirtualizacji (VBS): Uruchomiona
Jest to najważniejszy wymóg bezpieczeństwa. Aby je włączyć, upewnij się, że spełniasz wszystkie powyższe wymagania sprzętowe, a następnie włącz opcję "Izolacja rdzenia" -> "Integralność pamięci" w Zabezpieczeniach Windows.
Dlaczego stawiamy takie wymagania?
Ponieważ wierzymy, że fundamentem "bezpiecznego i czystego komputera" jest solidna, nowoczesna konfiguracja sprzętowa. Narzędzia zawarte w SecureWindowsToolkit są zaprojektowane tak, aby działać w synergii z tymi zaawansowanymi mechanizmami ochrony, a nie je zastępować.


