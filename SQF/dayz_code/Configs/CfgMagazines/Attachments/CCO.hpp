class Attachment_CCO : CA_Magazine
{
	scope = 2;
	count = 1;
	type = 256;	
	model = "\z\addons\dayz_communityweapons\attachments\cco\cco.p3d";
	picture = "\z\addons\dayz_communityweapons\attachments\cco\data\m_cco_ca.paa";	
	displayName = $STR_DZ_ATT_CCO_NAME;
	descriptionShort = $STR_DZ_ATT_CCO_DESC;
	
	class ItemActions
	{
		class AttachToPrimary
		{
			text = $STR_DZ_ATT_ACT_TO_PRIMARY;
			script = "; [_id,1] call player_attachAttachment";
		};
	};
};