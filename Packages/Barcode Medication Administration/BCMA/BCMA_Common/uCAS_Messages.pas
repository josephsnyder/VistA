unit uCAS_Messages;

interface

const
  msgImageNew =
    'Automation is Under construction.'+#13#10#13#10 +
    'To MANUALLY create new Image description:'+#13#10+
    '1. Create WP parameter to hold image data' + #13#10 +
    '2. Add new parameter name to the PSB AL IMAGES parameter';

  msgImageDelete =
    'Automation is Under construction.'+#13#10#13#10 +
    'To MANUALLY delete the Image description:'+#13#10+
    '1. Remove the name of parameter holding the image data from PSB AL IMAGES' + #13#10 +
    '2. Delete the parameter'+#13#10;

  msgLocationGroupNew =
    'Automation is Under construction.'+#13#10#13#10 +
    'To MANUALLY create new AL Group description:'+#13#10+
    '1. Create the parameter to hold Group data' + #13#10 +
    '2. Add new parameter name to the PSB AL GROUPS parameter';

  msgLocationGroupDelete =
    'Automation is Under construction.'+#13#10#13#10 +
    'To MANUALLY delete the AL Group description:'+#13#10+
    '1. Remove the name of parameter holding the group data from PSB AL GROUPS' + #13#10 +
    '2. Delete the parameter'+#13#10;

implementation

end.
