import os
from datetime import datetime
from pathlib import Path
from typing import Optional


class SessionLogger:
    def __init__(self, base_dir: Path = Path(os.getenv("ANTHROPIC_CONFIG_DIR", "~/.anthropic")).expanduser()):
        self.base_dir = base_dir
        self.logs_dir = base_dir / "logs"
        self.logs_dir.mkdir(parents=True, exist_ok=True)
        self.template_path = self.logs_dir / "template.md"
        self.current_file: Optional[Path] = None
        
    def start_session(self, request: str) -> Path:
        timestamp = datetime.now()
        filename = timestamp.strftime("%Y-%m-%d_%H%M%S.md")
        self.current_file = self.logs_dir / filename
        
        # Generate summary from first request
        summary = self._generate_summary(request)
        
        # Read template
        template = self.template_path.read_text()
        
        # Replace placeholders
        log_content = template.replace("# Subject -- short description of the request", 
                                     f"# {summary}")
        log_content = log_content.replace("$timestamp", 
                                        timestamp.strftime("%B %d, %Y at %H:%M:%S"))
        log_content = log_content.replace("Full request", request)
        log_content = log_content.replace("Response", "")  # Empty initially
        
        # Write to file
        self.current_file.write_text(log_content)
        return self.current_file
        
    def append_response(self, response: str) -> None:
        if not self.current_file:
            raise RuntimeError("No active session file")
            
        content = self.current_file.read_text()
        # Find the Response section and append
        parts = content.split("# Assistant")
        if len(parts) != 2:
            raise ValueError("Invalid log file format")
            
        new_content = parts[0] + "# Assistant\n" + response
        self.current_file.write_text(new_content)
        
    def _generate_summary(self, request: str) -> str:
        # Simple summary generation - take first line and truncate
        first_line = request.strip().split('\n')[0]
        return first_line[:50] + ('...' if len(first_line) > 50 else '')