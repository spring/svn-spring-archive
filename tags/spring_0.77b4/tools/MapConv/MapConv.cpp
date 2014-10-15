/// MapConv.cpp : Defines the entry point for the console application.
/// why it uses direct draw?,probably for direct draw surfaces(dds)

#include <iostream.h>
#include "Bitmap.h"
#include <string.h>     
#include <stdio.h>
#include "mapfile.h"
#include <fstream.h>   
#include "FileHandler.h"
#include <math.h>
#include "ddraw.h"                    
#include "FeatureCreator.h"
#include "TileHandler.h"
#include "tclap/CmdLine.h"
#include <vector.h>    
#include "time.h" 

using namespace std;
using namespace TCLAP;

CFeatureCreator featureCreator;

void ConvertTextures(string intexname,string temptexname,int xsize,int ysize);
void LoadHeightMap(string inname,int xsize,int ysize,float minHeight,float maxHeight,bool invert,bool lowpass,bool invertz,int smooth,int x,int y,float smoothval);
void SaveHeightMap(ofstream& outfile,int xsize,int ysize,float minHeight,float maxHeight);
void SaveTexOffsets(ofstream &outfile,string temptexname,int xsize,int ysize);
void SaveTextures(ofstream &outfile,string temptexname,int xsize,int ysize);

void SaveMiniMap(ofstream &outfile, bool fastminimap);
void SaveMetalMap(ofstream &outfile, std::string metalmap, int xsize, int ysize,int x,int y);
void SaveTypeMap(ofstream &outfile,int xsize,int ysize,string typemap,int x,int y);
void MapFeatures(const char *ffile, char *F_Array);

float* heightmap;
string stupidGlobalCompressorName;

int main(int argc, char ** argv)
{	
	int xsize;
	int ysize;
	string intexname="mars.bmp";
	string inHeightName="mars.raw";
	string outfilename="mars.smf";
	string metalmap="marsmetal.bmp";       
	string typemap="";
	string extTileFile="";
	string featuremap="";
	string geoVentFile="geovent.bmp";
	string featureListFile="fs.txt";
	float minHeight=20;
	float maxHeight=300;
	float compressFactor=0.8f;
	int quality=100; 
	int smooth=0;
	unsigned int x=0;
	unsigned int y=0;
	int filter=2; 
	//float whereisit=0;  unused.
	bool invertHeightMap=false;
	bool lowpassFilter=false;
	bool invertz=false;
	string option = "cfg.txt";
	vector<string> F_Spec;

	try {
		// Define the command line object.
		CmdLine cmd(
			"Converts a series of image files to a Spring map. This just creates the .smf and .smt files. You also need to write a .smd file using a text editor.",
			' ', "0.7");

		// Define a value argument and add it to the command line.
		ValueArg<string> optsArg("w", "options",
			"text file with special options",
			false, "cfg.txt","option file");
		cmd.add( optsArg );
		
		ValueArg<int> xsArg("r", "xscale",
			"scaling value for the map,this is the x map size,1 leaves the size to normal",
			false, 1,"xscaling");
		cmd.add( xsArg );
		ValueArg<int> ysArg("u", "yscale",
			"scaling value for the map,this is the y map size,1 leaves the size to normal",
			false, 1,"yscaling");
		cmd.add( ysArg );
		ValueArg<int> filterArg("b", "scalefilter",
			"filter for rescaling,only use if you are using rescaling,values are 1=fastest,2=medium,3=best,defaults to 2",
			false, 1,"scalefiltering");
		cmd.add( filterArg );
		ValueArg<int> qArg("q", "quality",
			"quality of the tiles, lower = faster,not recommended setting to very low values,defaults to 100",
			false, 100,"imagequality");
		cmd.add( qArg );
		ValueArg<int> flatArg("k", "Smooth",
			"like a global smooth on the heightmap,higher the height more it lowers,lower height less it lowers,must be a number from 0.00 to 1.00,defaults to 0",
			false, 0,"Smoothing");
		cmd.add( flatArg );
		SwitchArg invertzSwitch("p", "inverty",
			"inverts your map in the y axis,this means a place with 255 white will become 0 black,this is only applied after all other heightmap modifications are done",
			false);
		cmd.add( invertzSwitch );
		ValueArg<string> intexArg("t", "intex",
			"Input image to use for the map. Sides must be multiple of 1024 long. xsize, ysize determined from this file: xsize = intex width / 8, ysize = height / 8.",
			true, "test.bmp", "texturemap file");
		cmd.add( intexArg );
		ValueArg<string> heightArg("a", "heightmap",
			"Input heightmap to use for the map, this should be in 16 bit raw format (.raw extension) or an image file. Must be xsize*128+1 by ysize*128+1.",
			true, "test.raw", "heightmap file");
		cmd.add( heightArg );
		ValueArg<string> metalArg("m", "metalmap",
			"Metal map to use, red channel is amount of metal. Resized to xsize / 2 by ysize / 2.",
			true, "metal.bmp", "metalmap image");
		cmd.add( metalArg );
		ValueArg<string> typeArg("y","typemap",
			"Type map to use, uses the red channel to decide type. types are defined in the .smd, if this argument is skipped the map will be all type 0",
			false, "", "typemap image");
		cmd.add( typeArg );
		ValueArg<string> geoArg("g","geoventfile",
			"The decal for geothermal vents; appears on the compiled map at each vent. (Default: geovent.bmp).",
			false, "geovent.bmp", "Geovent image");
		cmd.add( geoArg );
		ValueArg<string> tileArg("e", "externaltilefile",
			"External tile file that will be used for finding tiles. Tiles not found in this will be saved in a new tile file.",
			false, "", "tile file");
		cmd.add( tileArg );
		ValueArg<string> outArg("o", "outfile",
			"The name of the created map file. Should end in .smf. A tilefile (extension .smt) is also created.",
			false, "test.smf", "output .smf");
		cmd.add( outArg );
		ValueArg<float> minhArg("n", "minheight",
			"What altitude in spring the min(0) level of the height map represents.",
			true, -20, "min height");
		cmd.add( minhArg );
		ValueArg<float> maxhArg("x", "maxheight",
			"What altitude in spring the max(0xff or 0xffff) level of the height map represents.",
			true, 500, "max height");
		cmd.add( maxhArg );
		ValueArg<float> compressArg("c", "compress",
			"How much we should try to compress the texture map. Default 0.8, lower -> higher quality, larger files.",
			false, 0.8f, "compression");
		cmd.add( compressArg );
		
		ValueArg<string> texCompressArg("z", "texcompress",
			"name the file containing the name of the program and its parameters for texture compression.",
			false, "texcompress", "texcompress program");
		cmd.add( texCompressArg );

		// Actually, it flips the heightmap *after* it's been read in. Hopefully this is clearer.
		SwitchArg invertSwitch("i", "invert",
			"Flip the height map image upside-down on reading,must be used on .bmp files.",
			false);
		cmd.add( invertSwitch );
		SwitchArg lowpassSwitch("l", "lowpass",
			"Lowpass smoothes the heightmap",
			false);
		cmd.add( lowpassSwitch );
		ValueArg<string> featureArg("f", "featuremap",
			"Feature placement file, xsize by ysize. See README.txt for details.",
			false, "", "featuremap image");
		cmd.add( featureArg );
		ValueArg<string> featureListArg("j", "featurelist",
			"A file with the name of one feature on each line. (Default: fs.txt). See README.txt for details.",
			false, "fs.txt", "feature list file");
		cmd.add( featureListArg );

		// Parse the args.
		cmd.parse( argc, argv );

		// Get the value parsed by each arg.
		
		y=ysArg.getValue();
		x=xsArg.getValue();
		
		option=optsArg.getValue();
		filter=filterArg.getValue();
		invertz=invertzSwitch.getValue();
		smooth=flatArg.getValue();
		quality=qArg.getValue();
		intexname=intexArg.getValue();
		inHeightName=heightArg.getValue();
		outfilename=outArg.getValue();
		typemap=typeArg.getValue();
		extTileFile=tileArg.getValue();
		metalmap=metalArg.getValue();
		minHeight=minhArg.getValue();
		maxHeight=maxhArg.getValue();
		compressFactor=compressArg.getValue();
		invertHeightMap=invertSwitch.getValue();
		lowpassFilter=lowpassSwitch.getValue();
		featuremap=featureArg.getValue();
		geoVentFile=geoArg.getValue();
		featureListFile=featureListArg.getValue();
		stupidGlobalCompressorName=texCompressArg.getValue();
		
	} catch (ArgException &e)  // catch any exceptions
	{ cerr << "error: " << e.error() << " for arg " << e.argId() << endl; exit(-1);}
	
	if (quality > 100)
		quality = 100;
	if (quality <= 0){
		cout << "quality cant be set to 0 or negative values" << endl;
        cout << "setting quality to 100" << endl;	
	}
	if (smooth < 0){
		cout << "smoothing can't be set to lower than 0, maybe later it will be allowed"; 
		smooth = 0; 
	}
		
	ifstream exec;
	
	exec.open(stupidGlobalCompressorName.c_str());
	if (!exec.is_open()){
	   stupidGlobalCompressorName = "nvdxt.exe -file temp\\Temp*.png -dxt1 -dither -point -fadeamount 0";
	   cout << "-z parameter was not specified, or the file was not found." << endl; 
	   cout << "using default value." << endl;
	}   
	if (exec.is_open())
	   getline(exec,stupidGlobalCompressorName);
	cout << stupidGlobalCompressorName << endl;
	
	exec.close();
	
	ifstream cfg;
	string configs[32];
	string format;
	float smoothval=0.0f;
	bool featuretolerance=false;
	bool ignoreheight=false;
	bool keepminimap=false;
	bool fastminimap=false;
	
	cfg.open(option.c_str(), ios::in );
	if (!cfg.is_open()){
		format="png";
		cout << "-w parameter was not specified, or the file was not found" << endl; 
		cout << "using default value" << endl;
		cout << "default image format is:" << format << "." << endl; 
	}if (cfg.is_open()){
	  for (int i=0;i<32;i++){
	    cfg >> configs[i];
	    //options.
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="featuretolerance"){ featuretolerance=true; cout << "found option featuretolerance in option file" << endl;}
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="ignoreheight"){ ignoreheight=true; cout << "found option ignoreheight in option file" << endl;}
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="keepminimap"){ keepminimap=true; cout << "found option keepminimap in option file" << endl;}	
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="minimap-fast"){ fastminimap=true; cout << "found option minimap-fast in option file" << endl;}	
	    //format of the tiles.
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formatbmp"){ format="bmp"; cout << "file format for tiles is:" << format << "." << endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formatpng"){ format="png"; cout << "file format for tiles is:" << format << "." <<endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formatjpg"){ format="jpg"; cout << "file format for tiles is:" << format << "." <<endl;}  
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formattga"){ format="tga"; cout << "file format for tiles is:" << format << "." <<endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formatdds"){ format="dds"; cout << "file format for tiles is:" << format << "." <<endl;}  
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formatraw"){ format="raw"; cout << "file format for tiles is:" << format << "." <<endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formatppm"){ format="ppm"; cout << "file format for tiles is:" << format << "." << endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formatrgb"){ format="rgb"; cout << "file format for tiles is:" << format << "." << endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="formattif"){ format="tif"; cout << "file format for tiles is:" << format << "." << endl;} 
	    //smoothing.
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="smooth3x3"){ smoothval=0.11f; cout << "smoothing matrix size is 3x3." << endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="smooth5x5"){ smoothval=0.04f; cout << "smoothing matrix size is 5x5." << endl;} 
	    if (configs[i].substr(0,configs[i].find_first_of(';'))=="smooth7x7"){ smoothval=0.0204f; cout << "smoothing matrix size is 7x7." << endl;} 
	  }
	}
	
	cfg.close();
	
	tileHandler.LoadTexture(intexname,x,y,filter);
	tileHandler.SetOutputFile(outfilename);
	
	if(!extTileFile.empty())
		tileHandler.AddExternalTileFile(extTileFile);

	xsize=tileHandler.xsize;
	ysize=tileHandler.ysize;
	
	LoadHeightMap(inHeightName,xsize,ysize,minHeight,maxHeight,invertHeightMap,lowpassFilter,invertz,smooth,x,y,smoothval);

	ifstream ifs;
	int numNamedFeatures=0;

	ifs.open(featureListFile.c_str(), ifstream::in);
	while (ifs.good()){
			char c[100]="";
			ifs.getline(c,100);
			F_Spec.push_back(c);
			numNamedFeatures++;
	}
	featureCreator.CreateFeatures(&tileHandler.bigTex,0,0,numNamedFeatures,featuremap,geoVentFile,x,y,ignoreheight,featuretolerance);

	tileHandler.ProcessTiles(compressFactor,quality,format);
	
	MapHeader header;
	strcpy(header.magic,"spring map file");
	header.version=1;
    
	cout << "calculating map id..." << endl;
	
	unsigned long long id = 0;
	unsigned long long id2 = 0;
	unsigned long long id3 = 0;
	int div = ((xsize+ysize)*3)/2;
	int mul = (((xsize+ysize)*2)+((xsize+ysize)*3));
	
	for (int ix=0;ix<xsize;ix++){
		for (int iz=0;iz<ysize;iz++){
			srand((ix*time(NULL))+(iz*time(NULL)));
			id = id+((unsigned long long)ceil(heightmap[iz*xsize+ix]*10));
		    id2 = (id2+id3)+(unsigned long long)(((ysize*xsize)*mul)/div)+(unsigned long long)(maxHeight+minHeight);
		    id3 = ((quality+numNamedFeatures)*((unsigned long long)ceil(compressFactor*10)))*((ix*iz)*mul); 
		    id = ((id+id2+id3)*(unsigned long long)rand())*(unsigned long long)rand();
		}      //this never fails.
	}                      
	
	ofstream fileid;
	
	fileid.open("mapid.txt", ios::out | ios::app);
	fileid << endl <<"current map id:" << id; 
	
	fileid.close();
	
	cout << "map id:" << id << endl;
	cout << "converting it to something that can be used in spring..." << endl;
	
	header.mapid=id;		//done,needs tests and fixes: this should be made better to make it depend on heightmap etc, but this should be enough to make each map unique

	cout << "map id:" << header.mapid << endl;
	
	header.mapx=xsize;
	header.mapy=ysize;
	header.squareSize=8;
	header.texelPerSquare=8;
	header.tilesize=32;
	header.minHeight=minHeight;
	header.maxHeight=maxHeight;

	header.numExtraHeaders=1;

	int headerSize=sizeof(MapHeader);
	headerSize+=12;		//size of vegetation extra header

	header.heightmapPtr = headerSize;
	header.typeMapPtr= header.heightmapPtr + (xsize+1)*(ysize+1)*2;
	header.minimapPtr = header.typeMapPtr + (xsize/2) * (ysize/2);
	header.tilesPtr = header.minimapPtr + MINIMAP_SIZE;
	header.metalmapPtr = header.tilesPtr + tileHandler.GetFileSize();
	header.featurePtr = header.metalmapPtr + (xsize/2)*(ysize/2) + (xsize/4*ysize/4);	//last one is space for vegetation map


	ofstream outfile(outfilename.c_str(), ios::out|ios::binary);

	outfile.write((char*)&header,sizeof(MapHeader));

	int temp=12;	//extra header size
	outfile.write((char*)&temp,4);
	temp=MEH_Vegetation;	//extra header type
	outfile.write((char*)&temp,4);
	temp=header.metalmapPtr + (xsize/2)*(ysize/2);		// offset to vegetation map
	outfile.write((char*)&temp,4);

	SaveHeightMap(outfile,xsize,ysize,minHeight,maxHeight);

	SaveTypeMap(outfile,xsize,ysize,typemap,x,y);
	SaveMiniMap(outfile, fastminimap);

	tileHandler.ProcessTiles2();
	tileHandler.SaveData(outfile);

	SaveMetalMap(outfile, metalmap,xsize,ysize,x,y);

	featureCreator.WriteToFile(&outfile, F_Spec,x,y);
	
	if (keepminimap == false){
	   system("del mini.png");
	   system("del mini.dds");
	}
	
	system("del temp\\Temp*.*");
	system("del temp\\Temp*.png.raw");
	system("del temp*.dds");

	delete[] heightmap;
	return 0;
}

void SaveMiniMap(ofstream &outfile, bool fastminimap)
{
	cout << "creating minimap..." << endl;

	CBitmap mini = tileHandler.bigTex.CreateRescaled(1024, 1024);
	mini.Save("mini.png",100);
	if (fastminimap == false)
	   system("nvdxt.exe -file mini.png -dxt1c -dither");
	if (fastminimap == true)
	   system("nvdxt.exe -file mini.png -quick -dxt1c -dither");
	
	DDSURFACEDESC2 ddsheader;
	int ddssignature;

	CFileHandler file("mini.dds");
	file.Read(&ddssignature, sizeof(int));
	file.Read(&ddsheader, sizeof(DDSURFACEDESC2));

	cout << "saving minimap..." << endl;
	
	char minidata[MINIMAP_SIZE];
	file.Read(minidata, MINIMAP_SIZE);

	outfile.write(minidata, MINIMAP_SIZE);
}

void LoadHeightMap(string inname,int xsize,int ysize,float minHeight,float maxHeight,bool invert,bool lowpass,bool invertz,int smooth,int x,int y,float smoothval)
{
	cout << "Creating height map..." << endl;
	
	float hDif=maxHeight-minHeight;
	int mapx=xsize+1;
	int mapy=ysize+1;
	
	heightmap=new float[mapx*mapy];
	
	if(inname.find(".raw")!=string::npos){		//16 bit raw
		CFileHandler fh(inname);
		    
		for(int y=0;y<mapy;++y){
			for(int x=0;x<mapx;++x){
				unsigned short h;
				fh.Read(&h,2);
				heightmap[(ysize-y)*mapx+x]=(float(h))/65535*hDif+minHeight;
			}
		}
	} else {	/////standard image
		cout << "loading heightmap image..." << endl; 
		CBitmap bm; 
		bm.Load(inname,255,x,y,3,true,2,false,false,false);
		if(bm.xsize!=mapx || bm.ysize!=mapy){
		   cout << "heightmap dimensions are wrong, rescaling it" << endl; 
           CBitmap bm2 = bm.Rescale((x*512)+1,(y*512)+1);  
		}
		for(int y=0;y<mapy;++y){
			for(int x=0;x<mapx;++x){
				unsigned short h=(int)bm.mem[(y*mapx+x)*4]*256;
				heightmap[(ysize-y)*mapx+x]=(float(h))/65535*hDif+minHeight;
			}
		}
	}
	
	if(invert){
		float* heightmap2=heightmap;
		heightmap=new float[mapx*mapy];
		for(int y=0;y<mapy;++y){
			for(int x=0;x<mapx;++x){
				heightmap[y*mapx+x]=heightmap2[(mapy-y-1)*mapx+x];
			}
		}
		delete[] heightmap2;
	}
	
	if(lowpass){
		float* heightmap2=heightmap;
		heightmap=new float[mapx*mapy];
		for(int y=0;y<mapy;++y){
			for(int x=0;x<mapx;++x){
				float h=0;
				float tmod=0;
				for(int y2=max(0,y-2);y2<min(mapy,y+3);++y2){
					int dy=y2-y;
					for(int x2=max(0,x-2);x2<min(mapx,x+3);++x2){
						int dx=x2-x;
						float mod=max(0.0f,1.0f-0.4f*sqrtf(float(dx*dx+dy*dy)));
						tmod+=mod;
						h+=heightmap2[y2*mapx+x2]*mod;
					}
				}
				heightmap[y*mapx+x]=h/tmod;
			}
		}
		delete[] heightmap2;	
	}
	if (smooth>0){
	   float mv = smoothval;
	   if (mv == 0.04f){  //5x5 matrix/
		  float sm[5][5];  
		  cout << "using a 5x5 matrix for smoothing..." << endl; 
	      for (int i=0;i<5;i++ ){
	      	 for (int j=0;j<5;j++){
	        	 sm[i][j]=mv;	  
	         }
	      }
	      for (int k=0;k<smooth;k++){
			  float* heightmap2=heightmap;
			  heightmap=new float[mapx*mapy]; 
	    	  cout << "smooth iteration number:" << k << endl; 
		      for(int y = 0;y < mapy; y++){ 
			   for (int x = 0;x < mapx; x++){
				   if (x < 3 || x > mapx-3 || y < 3 || y > mapy-3){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-2)*mapx+(x-2)] + sm[0][1] * heightmap2[(y-2)*mapx+(x-1)] + sm[0][2] * heightmap2[(y-2)*mapx+(x)] + sm[0][3] * heightmap2[(y-2)*mapx+(x+1)] + sm[0][4] * heightmap2[(y-2)*mapx+(x+2)] +
				                         sm[1][0] * heightmap2[(y-1)*mapx+(x-2)] + sm[1][1] * heightmap2[(y-1)*mapx+(x-1)] + sm[1][2] * heightmap2[(y-1)*mapx+(x)] + sm[1][3] * heightmap2[(y-1)*mapx+(x+1)] + sm[1][4] * heightmap2[(y-1)*mapx+(x+2)] +
				                         sm[2][0] * heightmap2[(y  )*mapx+(x-2)] + sm[2][1] * heightmap2[(y  )*mapx+(x-1)] + sm[2][2] * heightmap2[(y  )*mapx+(x)] + sm[2][3] * heightmap2[(y  )*mapx+(x+1)] + sm[2][4] * heightmap2[(y  )*mapx+(x+2)] +
				                         sm[3][0] * heightmap2[(y+1)*mapx+(x-2)] + sm[3][1] * heightmap2[(y+1)*mapx+(x-1)] + sm[3][2] * heightmap2[(y+1)*mapx+(x)] + sm[3][3] * heightmap2[(y+1)*mapx+(x+1)] + sm[3][4] * heightmap2[(y+1)*mapx+(x+2)] +
				                         sm[4][0] * heightmap2[(y+2)*mapx+(x-2)] + sm[4][1] * heightmap2[(y+2)*mapx+(x-1)] + sm[4][2] * heightmap2[(y+2)*mapx+(x)] + sm[4][3] * heightmap2[(y+2)*mapx+(x+1)] + sm[4][4] * heightmap2[(y+2)*mapx+(x+2)];
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]);
			   } 
		     }                             
		     for(int y = mapy;y < 0; y--){
			   for (int x = 0;x < mapx; x++){
				   if (x < 3 || x > mapx-3 || y < 3 || y > mapy-3){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-2)*mapx+(x-2)] + sm[0][1] * heightmap2[(y-2)*mapx+(x-1)] + sm[0][2] * heightmap2[(y-2)*mapx+(x)] + sm[0][3] * heightmap2[(y-2)*mapx+(x+1)] + sm[0][4] * heightmap2[(y-2)*mapx+(x+2)] +
				                         sm[1][0] * heightmap2[(y-1)*mapx+(x-2)] + sm[1][1] * heightmap2[(y-1)*mapx+(x-1)] + sm[1][2] * heightmap2[(y-1)*mapx+(x)] + sm[1][3] * heightmap2[(y-1)*mapx+(x+1)] + sm[1][4] * heightmap2[(y-1)*mapx+(x+2)] +
				                         sm[2][0] * heightmap2[(y  )*mapx+(x-2)] + sm[2][1] * heightmap2[(y  )*mapx+(x-1)] + sm[2][2] * heightmap2[(y  )*mapx+(x)] + sm[2][3] * heightmap2[(y  )*mapx+(x+1)] + sm[2][4] * heightmap2[(y  )*mapx+(x+2)] +
				                         sm[3][0] * heightmap2[(y+1)*mapx+(x-2)] + sm[3][1] * heightmap2[(y+1)*mapx+(x-1)] + sm[3][2] * heightmap2[(y+1)*mapx+(x)] + sm[3][3] * heightmap2[(y+1)*mapx+(x+1)] + sm[3][4] * heightmap2[(y+1)*mapx+(x+2)] +
				                         sm[4][0] * heightmap2[(y+2)*mapx+(x-2)] + sm[4][1] * heightmap2[(y+2)*mapx+(x-1)] + sm[4][2] * heightmap2[(y+2)*mapx+(x)] + sm[4][3] * heightmap2[(y+2)*mapx+(x+1)] + sm[4][4] * heightmap2[(y+2)*mapx+(x+2)];
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]);
			   }
		     } 	 
		     for(int y = 0;y < mapy; y++){
			   for (int x = 0;x < mapx; x++){
				   if (x < 3 || x > mapx-3 || y < 3 || y > mapy-3){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-2)*mapx+(x-2)] + sm[0][1] * heightmap2[(y-2)*mapx+(x-1)] + sm[0][2] * heightmap2[(y-2)*mapx+(x)] + sm[0][3] * heightmap2[(y-2)*mapx+(x+1)] + sm[0][4] * heightmap2[(y-2)*mapx+(x+2)] +
				                         sm[1][0] * heightmap2[(y-1)*mapx+(x-2)] + sm[1][1] * heightmap2[(y-1)*mapx+(x-1)] + sm[1][2] * heightmap2[(y-1)*mapx+(x)] + sm[1][3] * heightmap2[(y-1)*mapx+(x+1)] + sm[1][4] * heightmap2[(y-1)*mapx+(x+2)] +
				                         sm[2][0] * heightmap2[(y  )*mapx+(x-2)] + sm[2][1] * heightmap2[(y  )*mapx+(x-1)] + sm[2][2] * heightmap2[(y  )*mapx+(x)] + sm[2][3] * heightmap2[(y  )*mapx+(x+1)] + sm[2][4] * heightmap2[(y  )*mapx+(x+2)] +
				                         sm[3][0] * heightmap2[(y+1)*mapx+(x-2)] + sm[3][1] * heightmap2[(y+1)*mapx+(x-1)] + sm[3][2] * heightmap2[(y+1)*mapx+(x)] + sm[3][3] * heightmap2[(y+1)*mapx+(x+1)] + sm[3][4] * heightmap2[(y+1)*mapx+(x+2)] +
				                         sm[4][0] * heightmap2[(y+2)*mapx+(x-2)] + sm[4][1] * heightmap2[(y+2)*mapx+(x-1)] + sm[4][2] * heightmap2[(y+2)*mapx+(x)] + sm[4][3] * heightmap2[(y+2)*mapx+(x+1)] + sm[4][4] * heightmap2[(y+2)*mapx+(x+2)];
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]);	 
			   }
		     }    
		     for(int y = 0;y < mapx; y++){
			   for (int x = mapy; x < 0; x--){
				   if (x < 3 || x > mapx-3 || y < 3 || y > mapy-3){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-2)*mapx+(x-2)] + sm[0][1] * heightmap2[(y-2)*mapx+(x-1)] + sm[0][2] * heightmap2[(y-2)*mapx+(x)] + sm[0][3] * heightmap2[(y-2)*mapx+(x+1)] + sm[0][4] * heightmap2[(y-2)*mapx+(x+2)] +
				                         sm[1][0] * heightmap2[(y-1)*mapx+(x-2)] + sm[1][1] * heightmap2[(y-1)*mapx+(x-1)] + sm[1][2] * heightmap2[(y-1)*mapx+(x)] + sm[1][3] * heightmap2[(y-1)*mapx+(x+1)] + sm[1][4] * heightmap2[(y-1)*mapx+(x+2)] +
				                         sm[2][0] * heightmap2[(y  )*mapx+(x-2)] + sm[2][1] * heightmap2[(y  )*mapx+(x-1)] + sm[2][2] * heightmap2[(y  )*mapx+(x)] + sm[2][3] * heightmap2[(y  )*mapx+(x+1)] + sm[2][4] * heightmap2[(y  )*mapx+(x+2)] +
				                         sm[3][0] * heightmap2[(y+1)*mapx+(x-2)] + sm[3][1] * heightmap2[(y+1)*mapx+(x-1)] + sm[3][2] * heightmap2[(y+1)*mapx+(x)] + sm[3][3] * heightmap2[(y+1)*mapx+(x+1)] + sm[3][4] * heightmap2[(y+1)*mapx+(x+2)] +
				                         sm[4][0] * heightmap2[(y+2)*mapx+(x-2)] + sm[4][1] * heightmap2[(y+2)*mapx+(x-1)] + sm[4][2] * heightmap2[(y+2)*mapx+(x)] + sm[4][3] * heightmap2[(y+2)*mapx+(x+1)] + sm[4][4] * heightmap2[(y+2)*mapx+(x+2)];
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]);
			   }
		     }   
		     delete[] heightmap2;
	      } 
	    }   
	   if (mv == 0.0204f){ //7x7 matrix
		  float sm[7][7];  
		  cout << "using a 7x7 matrix for smoothing..." << endl; 
	      for (int i=0;i<7;i++ ){
	      	 for (int j=0;j<7;j++){
	        	 sm[i][j]=mv;	  
	         }
	      }
	      for (int k=0;k<smooth;k++){
			  float* heightmap2=heightmap;
			  heightmap=new float[mapx*mapy]; 
	    	  cout << "smooth iteration number:" << k << endl; 
		      for(int y = 0;y < mapy; y++){ 
			   for (int x = 0;x < mapx; x++){
				   if (x < 4 || x > mapx-4 || y < 4 || y > mapy-4){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-3)*mapx+(x-3)] + sm[0][1] * heightmap2[(y-3)*mapx+(x-2)] + sm[0][2] * heightmap2[(y-3)*mapx+(x-1)] + sm[0][3] * heightmap2[(y-3)*mapx+(x  )] + sm[0][4] * heightmap2[(y-3)*mapx+(x+1)] + sm[0][5] * heightmap2[(y-3)*mapx+(x+2)] + sm[0][6] * heightmap2[(y-3)*mapx+(x+3)]+ 
				                         sm[1][0] * heightmap2[(y-2)*mapx+(x-3)] + sm[1][1] * heightmap2[(y-2)*mapx+(x-2)] + sm[1][2] * heightmap2[(y-2)*mapx+(x-1)] + sm[1][3] * heightmap2[(y-2)*mapx+(x  )] + sm[1][4] * heightmap2[(y-2)*mapx+(x+1)] + sm[1][5] * heightmap2[(y-2)*mapx+(x+2)] + sm[1][6] * heightmap2[(y-2)*mapx+(x+3)]+ 
				                         sm[2][0] * heightmap2[(y-1)*mapx+(x-3)] + sm[2][1] * heightmap2[(y-1)*mapx+(x-2)] + sm[2][2] * heightmap2[(y-1)*mapx+(x-1)] + sm[2][3] * heightmap2[(y-1)*mapx+(x  )] + sm[2][4] * heightmap2[(y-1)*mapx+(x+1)] + sm[2][5] * heightmap2[(y-1)*mapx+(x+2)] + sm[2][6] * heightmap2[(y-1)*mapx+(x+3)]+ 
				                         sm[3][0] * heightmap2[(y  )*mapx+(x-3)] + sm[3][1] * heightmap2[(y  )*mapx+(x-2)] + sm[3][2] * heightmap2[(y  )*mapx+(x-1)] + sm[3][3] * heightmap2[(y  )*mapx+(x  )] + sm[3][4] * heightmap2[(y  )*mapx+(x+1)] + sm[3][5] * heightmap2[(y  )*mapx+(x+2)] + sm[3][6] * heightmap2[(y  )*mapx+(x+3)]+ 
				                         sm[4][0] * heightmap2[(y+1)*mapx+(x-3)] + sm[4][1] * heightmap2[(y+1)*mapx+(x-2)] + sm[4][2] * heightmap2[(y+1)*mapx+(x-1)] + sm[4][3] * heightmap2[(y+1)*mapx+(x  )] + sm[4][4] * heightmap2[(y+1)*mapx+(x+1)] + sm[4][5] * heightmap2[(y+1)*mapx+(x+2)] + sm[4][6] * heightmap2[(y+1)*mapx+(x+3)]+ 
				                         sm[5][0] * heightmap2[(y+2)*mapx+(x-3)] + sm[5][1] * heightmap2[(y+2)*mapx+(x-2)] + sm[5][2] * heightmap2[(y+2)*mapx+(x-1)] + sm[5][3] * heightmap2[(y+2)*mapx+(x  )] + sm[5][4] * heightmap2[(y+2)*mapx+(x+1)] + sm[5][5] * heightmap2[(y+2)*mapx+(x+2)] + sm[5][6] * heightmap2[(y+2)*mapx+(x+3)]+ 
				                         sm[6][0] * heightmap2[(y+3)*mapx+(x-3)] + sm[6][1] * heightmap2[(y+3)*mapx+(x-2)] + sm[6][2] * heightmap2[(y+3)*mapx+(x-1)] + sm[6][3] * heightmap2[(y+3)*mapx+(x  )] + sm[6][4] * heightmap2[(y+3)*mapx+(x+1)] + sm[6][5] * heightmap2[(y+3)*mapx+(x+2)] + sm[6][6] * heightmap2[(y+3)*mapx+(x+3)]; 				                         
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+sm[0][5]+sm[0][6]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+sm[1][5]+sm[1][6]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+sm[2][5]+sm[2][6]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+sm[3][5]+sm[3][6]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]+sm[4][5]+sm[4][6]+
		        		                                        sm[5][0]+sm[5][1]+sm[5][2]+sm[5][3]+sm[5][4]+sm[5][5]+sm[5][6]+
		        		                                        sm[6][0]+sm[6][1]+sm[6][2]+sm[6][3]+sm[6][4]+sm[6][5]+sm[6][6]);
			   } 
		     }                             
		     for(int y = mapy;y < 0; y--){
			   for (int x = 0;x < mapx; x++){
				   if (x < 4 || x > mapx-4 || y < 4 || y > mapy-4){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-3)*mapx+(x-3)] + sm[0][1] * heightmap2[(y-3)*mapx+(x-2)] + sm[0][2] * heightmap2[(y-3)*mapx+(x-1)] + sm[0][3] * heightmap2[(y-3)*mapx+(x  )] + sm[0][4] * heightmap2[(y-3)*mapx+(x+1)] + sm[0][5] * heightmap2[(y-3)*mapx+(x+2)] + sm[0][6] * heightmap2[(y-3)*mapx+(x+3)]+ 
				                         sm[1][0] * heightmap2[(y-2)*mapx+(x-3)] + sm[1][1] * heightmap2[(y-2)*mapx+(x-2)] + sm[1][2] * heightmap2[(y-2)*mapx+(x-1)] + sm[1][3] * heightmap2[(y-2)*mapx+(x  )] + sm[1][4] * heightmap2[(y-2)*mapx+(x+1)] + sm[1][5] * heightmap2[(y-2)*mapx+(x+2)] + sm[1][6] * heightmap2[(y-2)*mapx+(x+3)]+ 
				                         sm[2][0] * heightmap2[(y-1)*mapx+(x-3)] + sm[2][1] * heightmap2[(y-1)*mapx+(x-2)] + sm[2][2] * heightmap2[(y-1)*mapx+(x-1)] + sm[2][3] * heightmap2[(y-1)*mapx+(x  )] + sm[2][4] * heightmap2[(y-1)*mapx+(x+1)] + sm[2][5] * heightmap2[(y-1)*mapx+(x+2)] + sm[2][6] * heightmap2[(y-1)*mapx+(x+3)]+ 
				                         sm[3][0] * heightmap2[(y  )*mapx+(x-3)] + sm[3][1] * heightmap2[(y  )*mapx+(x-2)] + sm[3][2] * heightmap2[(y  )*mapx+(x-1)] + sm[3][3] * heightmap2[(y  )*mapx+(x  )] + sm[3][4] * heightmap2[(y  )*mapx+(x+1)] + sm[3][5] * heightmap2[(y  )*mapx+(x+2)] + sm[3][6] * heightmap2[(y  )*mapx+(x+3)]+ 
				                         sm[4][0] * heightmap2[(y+1)*mapx+(x-3)] + sm[4][1] * heightmap2[(y+1)*mapx+(x-2)] + sm[4][2] * heightmap2[(y+1)*mapx+(x-1)] + sm[4][3] * heightmap2[(y+1)*mapx+(x  )] + sm[4][4] * heightmap2[(y+1)*mapx+(x+1)] + sm[4][5] * heightmap2[(y+1)*mapx+(x+2)] + sm[4][6] * heightmap2[(y+1)*mapx+(x+3)]+ 
				                         sm[5][0] * heightmap2[(y+2)*mapx+(x-3)] + sm[5][1] * heightmap2[(y+2)*mapx+(x-2)] + sm[5][2] * heightmap2[(y+2)*mapx+(x-1)] + sm[5][3] * heightmap2[(y+2)*mapx+(x  )] + sm[5][4] * heightmap2[(y+2)*mapx+(x+1)] + sm[5][5] * heightmap2[(y+2)*mapx+(x+2)] + sm[5][6] * heightmap2[(y+2)*mapx+(x+3)]+ 
				                         sm[6][0] * heightmap2[(y+3)*mapx+(x-3)] + sm[6][1] * heightmap2[(y+3)*mapx+(x-2)] + sm[6][2] * heightmap2[(y+3)*mapx+(x-1)] + sm[6][3] * heightmap2[(y+3)*mapx+(x  )] + sm[6][4] * heightmap2[(y+3)*mapx+(x+1)] + sm[6][5] * heightmap2[(y+3)*mapx+(x+2)] + sm[6][6] * heightmap2[(y+3)*mapx+(x+3)]; 				                         
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+sm[0][5]+sm[0][6]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+sm[1][5]+sm[1][6]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+sm[2][5]+sm[2][6]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+sm[3][5]+sm[3][6]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]+sm[4][5]+sm[4][6]+
		        		                                        sm[5][0]+sm[5][1]+sm[5][2]+sm[5][3]+sm[5][4]+sm[5][5]+sm[5][6]+
		        		                                        sm[6][0]+sm[6][1]+sm[6][2]+sm[6][3]+sm[6][4]+sm[6][5]+sm[6][6]);
			   } 
		     } 	 
		     for(int y = 0;y < mapy; y++){
			   for (int x = 0;x < mapx; x++){
				   if (x < 4 || x > mapx-4 || y < 4 || y > mapy-4){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-3)*mapx+(x-3)] + sm[0][1] * heightmap2[(y-3)*mapx+(x-2)] + sm[0][2] * heightmap2[(y-3)*mapx+(x-1)] + sm[0][3] * heightmap2[(y-3)*mapx+(x  )] + sm[0][4] * heightmap2[(y-3)*mapx+(x+1)] + sm[0][5] * heightmap2[(y-3)*mapx+(x+2)] + sm[0][6] * heightmap2[(y-3)*mapx+(x+3)]+ 
				                         sm[1][0] * heightmap2[(y-2)*mapx+(x-3)] + sm[1][1] * heightmap2[(y-2)*mapx+(x-2)] + sm[1][2] * heightmap2[(y-2)*mapx+(x-1)] + sm[1][3] * heightmap2[(y-2)*mapx+(x  )] + sm[1][4] * heightmap2[(y-2)*mapx+(x+1)] + sm[1][5] * heightmap2[(y-2)*mapx+(x+2)] + sm[1][6] * heightmap2[(y-2)*mapx+(x+3)]+ 
				                         sm[2][0] * heightmap2[(y-1)*mapx+(x-3)] + sm[2][1] * heightmap2[(y-1)*mapx+(x-2)] + sm[2][2] * heightmap2[(y-1)*mapx+(x-1)] + sm[2][3] * heightmap2[(y-1)*mapx+(x  )] + sm[2][4] * heightmap2[(y-1)*mapx+(x+1)] + sm[2][5] * heightmap2[(y-1)*mapx+(x+2)] + sm[2][6] * heightmap2[(y-1)*mapx+(x+3)]+ 
				                         sm[3][0] * heightmap2[(y  )*mapx+(x-3)] + sm[3][1] * heightmap2[(y  )*mapx+(x-2)] + sm[3][2] * heightmap2[(y  )*mapx+(x-1)] + sm[3][3] * heightmap2[(y  )*mapx+(x  )] + sm[3][4] * heightmap2[(y  )*mapx+(x+1)] + sm[3][5] * heightmap2[(y  )*mapx+(x+2)] + sm[3][6] * heightmap2[(y  )*mapx+(x+3)]+ 
				                         sm[4][0] * heightmap2[(y+1)*mapx+(x-3)] + sm[4][1] * heightmap2[(y+1)*mapx+(x-2)] + sm[4][2] * heightmap2[(y+1)*mapx+(x-1)] + sm[4][3] * heightmap2[(y+1)*mapx+(x  )] + sm[4][4] * heightmap2[(y+1)*mapx+(x+1)] + sm[4][5] * heightmap2[(y+1)*mapx+(x+2)] + sm[4][6] * heightmap2[(y+1)*mapx+(x+3)]+ 
				                         sm[5][0] * heightmap2[(y+2)*mapx+(x-3)] + sm[5][1] * heightmap2[(y+2)*mapx+(x-2)] + sm[5][2] * heightmap2[(y+2)*mapx+(x-1)] + sm[5][3] * heightmap2[(y+2)*mapx+(x  )] + sm[5][4] * heightmap2[(y+2)*mapx+(x+1)] + sm[5][5] * heightmap2[(y+2)*mapx+(x+2)] + sm[5][6] * heightmap2[(y+2)*mapx+(x+3)]+ 
				                         sm[6][0] * heightmap2[(y+3)*mapx+(x-3)] + sm[6][1] * heightmap2[(y+3)*mapx+(x-2)] + sm[6][2] * heightmap2[(y+3)*mapx+(x-1)] + sm[6][3] * heightmap2[(y+3)*mapx+(x  )] + sm[6][4] * heightmap2[(y+3)*mapx+(x+1)] + sm[6][5] * heightmap2[(y+3)*mapx+(x+2)] + sm[6][6] * heightmap2[(y+3)*mapx+(x+3)]; 				                         
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+sm[0][5]+sm[0][6]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+sm[1][5]+sm[1][6]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+sm[2][5]+sm[2][6]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+sm[3][5]+sm[3][6]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]+sm[4][5]+sm[4][6]+
		        		                                        sm[5][0]+sm[5][1]+sm[5][2]+sm[5][3]+sm[5][4]+sm[5][5]+sm[5][6]+
		        		                                        sm[6][0]+sm[6][1]+sm[6][2]+sm[6][3]+sm[6][4]+sm[6][5]+sm[6][6]);
			   } 
		     }    
		     for(int y = 0;y < mapx; y++){
			   for (int x = mapy; x < 0; x--){
				   if (x < 4 || x > mapx-4 || y < 4 || y > mapy-4){
					   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					   continue;
				   }
				   heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-3)*mapx+(x-3)] + sm[0][1] * heightmap2[(y-3)*mapx+(x-2)] + sm[0][2] * heightmap2[(y-3)*mapx+(x-1)] + sm[0][3] * heightmap2[(y-3)*mapx+(x  )] + sm[0][4] * heightmap2[(y-3)*mapx+(x+1)] + sm[0][5] * heightmap2[(y-3)*mapx+(x+2)] + sm[0][6] * heightmap2[(y-3)*mapx+(x+3)]+ 
				                         sm[1][0] * heightmap2[(y-2)*mapx+(x-3)] + sm[1][1] * heightmap2[(y-2)*mapx+(x-2)] + sm[1][2] * heightmap2[(y-2)*mapx+(x-1)] + sm[1][3] * heightmap2[(y-2)*mapx+(x  )] + sm[1][4] * heightmap2[(y-2)*mapx+(x+1)] + sm[1][5] * heightmap2[(y-2)*mapx+(x+2)] + sm[1][6] * heightmap2[(y-2)*mapx+(x+3)]+ 
				                         sm[2][0] * heightmap2[(y-1)*mapx+(x-3)] + sm[2][1] * heightmap2[(y-1)*mapx+(x-2)] + sm[2][2] * heightmap2[(y-1)*mapx+(x-1)] + sm[2][3] * heightmap2[(y-1)*mapx+(x  )] + sm[2][4] * heightmap2[(y-1)*mapx+(x+1)] + sm[2][5] * heightmap2[(y-1)*mapx+(x+2)] + sm[2][6] * heightmap2[(y-1)*mapx+(x+3)]+ 
				                         sm[3][0] * heightmap2[(y  )*mapx+(x-3)] + sm[3][1] * heightmap2[(y  )*mapx+(x-2)] + sm[3][2] * heightmap2[(y  )*mapx+(x-1)] + sm[3][3] * heightmap2[(y  )*mapx+(x  )] + sm[3][4] * heightmap2[(y  )*mapx+(x+1)] + sm[3][5] * heightmap2[(y  )*mapx+(x+2)] + sm[3][6] * heightmap2[(y  )*mapx+(x+3)]+ 
				                         sm[4][0] * heightmap2[(y+1)*mapx+(x-3)] + sm[4][1] * heightmap2[(y+1)*mapx+(x-2)] + sm[4][2] * heightmap2[(y+1)*mapx+(x-1)] + sm[4][3] * heightmap2[(y+1)*mapx+(x  )] + sm[4][4] * heightmap2[(y+1)*mapx+(x+1)] + sm[4][5] * heightmap2[(y+1)*mapx+(x+2)] + sm[4][6] * heightmap2[(y+1)*mapx+(x+3)]+ 
				                         sm[5][0] * heightmap2[(y+2)*mapx+(x-3)] + sm[5][1] * heightmap2[(y+2)*mapx+(x-2)] + sm[5][2] * heightmap2[(y+2)*mapx+(x-1)] + sm[5][3] * heightmap2[(y+2)*mapx+(x  )] + sm[5][4] * heightmap2[(y+2)*mapx+(x+1)] + sm[5][5] * heightmap2[(y+2)*mapx+(x+2)] + sm[5][6] * heightmap2[(y+2)*mapx+(x+3)]+ 
				                         sm[6][0] * heightmap2[(y+3)*mapx+(x-3)] + sm[6][1] * heightmap2[(y+3)*mapx+(x-2)] + sm[6][2] * heightmap2[(y+3)*mapx+(x-1)] + sm[6][3] * heightmap2[(y+3)*mapx+(x  )] + sm[6][4] * heightmap2[(y+3)*mapx+(x+1)] + sm[6][5] * heightmap2[(y+3)*mapx+(x+2)] + sm[6][6] * heightmap2[(y+3)*mapx+(x+3)]; 				                         
		           heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+sm[0][3]+sm[0][4]+sm[0][5]+sm[0][6]+
		        		                                        sm[1][0]+sm[1][1]+sm[1][2]+sm[1][3]+sm[1][4]+sm[1][5]+sm[1][6]+
		        		                                        sm[2][0]+sm[2][1]+sm[2][2]+sm[2][3]+sm[2][4]+sm[2][5]+sm[2][6]+
		        		                                        sm[3][0]+sm[3][1]+sm[3][2]+sm[3][3]+sm[3][4]+sm[3][5]+sm[3][6]+
		        		                                        sm[4][0]+sm[4][1]+sm[4][2]+sm[4][3]+sm[4][4]+sm[4][5]+sm[4][6]+
		        		                                        sm[5][0]+sm[5][1]+sm[5][2]+sm[5][3]+sm[5][4]+sm[5][5]+sm[5][6]+
		        		                                        sm[6][0]+sm[6][1]+sm[6][2]+sm[6][3]+sm[6][4]+sm[6][5]+sm[6][6]);
			   } 
		     }   
		     delete[] heightmap2;
	      } 
	    }   
		if (mv == 0.11f){   //3x3 matrix
		   float sm[3][3];  
		   cout << "using a 3x3 matrix for smoothing..." << endl; 
	       for (int i=0;i<3;i++ ){
	       	   for (int j=0;j<3;j++){
	        	   sm[i][j]=mv;	  
	       	   }
	       }
		   for (int k=0;k<smooth;k++){
			   float* heightmap2=heightmap;
			   heightmap=new float[mapx*mapy];
		       cout << "smooth iteration number:" << k << endl; 
			   for(int y = 0;y < mapx; y++){
			      for (int x = 0;x < mapy; x++){
					   if (x < 2 || x > mapx-2 || y < 3 || y > mapy-2){
						   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
						   continue;
					   }
				      heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-1)*mapx+(x-1)] + sm[0][1] * heightmap2[(y-1)*mapx+(x)] + sm[0][2] * heightmap2[(y-1)*mapx+(x+1)] +
				                            sm[1][0] * heightmap2[(y  )*mapx+(x-1)] + sm[1][1] * heightmap2[(y  )*mapx+(x)] + sm[1][2] * heightmap2[(y  )*mapx+(x+1)] + 
				                            sm[2][0] * heightmap2[(y+1)*mapx+(x-1)] + sm[2][1] * heightmap2[(y+1)*mapx+(x)] + sm[2][2] * heightmap2[(y+1)*mapx+(x+1)]; 
			          heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+
			        	    	                                   sm[1][0]+sm[1][1]+sm[1][2]+
			        		                                       sm[2][0]+sm[2][1]+sm[2][2]);
				  } 
			   }                             
			   for(int y = mapx;y < 0; y--){
				  for (int x = 0;x < mapy; x++){
					   if (x < 2 || x > mapx-2 || y < 3 || y > mapy-2){
						   heightmap[y*mapx+x] = heightmap2[y*mapx+x];
						   continue;
					   }
					  heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-1)*mapx+(x-1)] + sm[0][1] * heightmap2[(y-1)*mapx+(x)] + sm[0][2] * heightmap2[(y-1)*mapx+(x+1)] +
						                    sm[1][0] * heightmap2[(y  )*mapx+(x-1)] + sm[1][1] * heightmap2[(y  )*mapx+(x)] + sm[1][2] * heightmap2[(y  )*mapx+(x+1)] + 
						                    sm[2][0] * heightmap2[(y+1)*mapx+(x-1)] + sm[2][1] * heightmap2[(y+1)*mapx+(x)] + sm[2][2] * heightmap2[(y+1)*mapx+(x+1)]; 
				      heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+
				            	                                   sm[1][0]+sm[1][1]+sm[1][2]+
				        		                                   sm[2][0]+sm[2][1]+sm[2][2]);
				  }
			   } 	 
			   for(int y = 0;y < mapx; y++){
				  for (int x = 1;x < mapy; x++){
					  if (x < 2 || x > mapx-2 || y < 2 || y > mapy-2){
						  heightmap[y*mapx+x] = heightmap2[y*mapx+x];
						  continue;
					  }
					  heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-1)*mapx+(x-1)] + sm[0][1] * heightmap2[(y-1)*mapx+(x)] + sm[0][2] * heightmap2[(y-1)*mapx+(x+1)] +
					                        sm[1][0] * heightmap2[(y  )*mapx+(x-1)] + sm[1][1] * heightmap2[(y  )*mapx+(x)] + sm[1][2] * heightmap2[(y  )*mapx+(x+1)] + 
					                        sm[2][0] * heightmap2[(y+1)*mapx+(x-1)] + sm[2][1] * heightmap2[(y+1)*mapx+(x)] + sm[2][2] * heightmap2[(y+1)*mapx+(x+1)]; 
				      heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+
				             	                                   sm[1][0]+sm[1][1]+sm[1][2]+
				        		                                   sm[2][0]+sm[2][1]+sm[2][2]);	 
				  }
			   }    
			   for(int y = 0;y < mapx; y++){
				  for (int x = mapy; x < 0; x--){
					  if (x < 2 || x > mapx-2 || y < 2 || y > mapy-2){
						  heightmap[y*mapx+x] = heightmap2[y*mapx+x];
					      continue;
					  } 
				      heightmap[y*mapx+x] = sm[0][0] * heightmap2[(y-1)*mapx+(x-1)] + sm[0][1] * heightmap2[(y-1)*mapx+(x)] + sm[0][2] * heightmap2[(y-1)*mapx+(x+1)] +
					                        sm[1][0] * heightmap2[(y  )*mapx+(x-1)] + sm[1][1] * heightmap2[(y  )*mapx+(x)] + sm[1][2] * heightmap2[(y  )*mapx+(x+1)] + 
						                    sm[2][0] * heightmap2[(y+1)*mapx+(x-1)] + sm[2][1] * heightmap2[(y+1)*mapx+(x)] + sm[2][2] * heightmap2[(y+1)*mapx+(x+1)]; 
				      heightmap[y*mapx+x] = heightmap[y*mapx+x] / (sm[0][0]+sm[0][1]+sm[0][2]+
				        		                                   sm[1][0]+sm[1][1]+sm[1][2]+
				        		                                   sm[2][0]+sm[2][1]+sm[2][2]);
				  }
			   }  
			   delete[] heightmap2;   
		   }
		}
	}
	
    float value = 0;
	if(invertz){
		float* heightmap2=heightmap;
		heightmap=new float[mapx*mapy];
		for(int y=0;y<mapy;++y){
			for(int x=0;x<mapx;++x){
               value = heightmap2[y*mapx+x] - maxHeight;
               heightmap2[y*mapx+x] = value;            
			}
		}
		heightmap=heightmap2;
	}
}

void SaveHeightMap(ofstream& outfile,int xsize,int ysize,float minHeight,float maxHeight)
{
	cout << "saving heightmap..." << endl;
	
	int mapx=xsize+1;
	int mapy=ysize+1;
	unsigned short* hm=new unsigned short[mapx*mapy];
	float sub=minHeight;
	float mul=(1.0f/(maxHeight-minHeight))*0xffff;
	for(int y=0;y<mapy;++y){
		for(int x=0;x<mapx;++x){
			hm[y*mapx+x]=(unsigned short)((heightmap[y*mapx+x]-sub)*mul);
		}
	}
	outfile.write((char*)hm,mapx*mapy*2);

	delete[] hm;
}

void SaveMetalMap(ofstream &outfile, std::string metalmap, int xsize, int ysize,int x,int y)
{
	cout << "Saving metal map..." << endl;

	CBitmap metal(metalmap,x,y,true,3,false,false,false);
	if(metal.xsize!=xsize/2 || metal.ysize!=ysize/2){
		metal=metal.CreateRescaled(xsize/2,ysize/2);
	}
	int size = (xsize/2)*(ysize/2);
	char *buf = new char[size];

	for(int y=0;y<metal.ysize;++y)
		for(int x=0;x<metal.xsize;++x)
			buf[y*metal.xsize+x]=metal.mem[(y*metal.xsize+x)*4];	//we use the red component of the picture

	outfile.write(buf, size);

	delete [] buf;
}

void SaveTypeMap(ofstream &outfile,int xsize,int ysize,string typemap,int x,int y)
{
	cout << "saving type map..." << endl;
	
	int mapx=xsize/2;
	int mapy=ysize/2;

	unsigned char* typeMapMem=new unsigned char[mapx*mapy];
	memset(typeMapMem,0,mapx*mapy);

	if(!typemap.empty()){
		CBitmap tm;
		tm.Load(typemap,255,x,y,2,false,6,false,true,false);
		CBitmap tm2=tm.CreateRescaled(mapx,mapy);
		for(int a=0;a<mapx*mapy;++a)
			typeMapMem[a]=tm2.mem[a*4];
	}
	
	outfile.write((char*)typeMapMem,mapx*mapy);

	delete[] typeMapMem;
}

