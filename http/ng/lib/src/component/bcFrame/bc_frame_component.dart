import 'package:angular/angular.dart';
import 'package:angular/security.dart';

@Component(
  selector: 'bc-iframe',
  template: '''
    <h3>Blockchain UI</h3>
    <iframe frameBorder="0" style="width: 100%; height: -webkit-fill-available;" src="{{safeUrl}}"></iframe>
  ''',
  styleUrls: ['bc_frame_component.css']
)
class BcFrameComponent implements OnInit {
  DomSanitizationService _sanitizer;
  final String _currentContent = "http://neverssl.com/";
  SafeResourceUrl safeUrl;
  void setUrl(){
    print("Sanitizing: $_currentContent");
    safeUrl = _sanitizer.bypassSecurityTrustResourceUrl(_currentContent);
  }

  BcFrameComponent(this._sanitizer);

  @override
  void ngOnInit(){
    setUrl();
  }
}
