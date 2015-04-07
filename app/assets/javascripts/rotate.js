function rlog(a) {}


function RotateToolManager() {
    rlog("RotateToolManager start...");
    var instances = new Array();
    this.add = function (params) {
        if (!params.target) {
            alert("No target div set for the 3DRT!");
            return
        }
        var target = params.target;
        if (instances[target]) {
            alert("Rotate Tool with target: " + target + " was already initialized!")
        } else {
            instances[target] = new RotateToolInstance(params)
        }
    };
    this.checkXMLLoad = function (target) {
        if (instances[target] && instances[target].isXMLLoaded == false) {
            alert("Failed loading xml: " + instances[target].getPathToConfig())
        }
    };
    this.xmlLoaded = function (target, data) {
        rlog("xml loaded");
        instances[target].isXMLLoaded = true;
        instances[target].xmlLoaded(data)
    };
    this.rotate = function (target) {
        instances[target].showNextImage()
    };
    var RotateToolInstance = function (params) {
        if (!params.path) {
            params.path = ""
        }
        if (!params.target) {
            return false
        }
        if (!params.configFile) {
            params.configFile = (params.xml == true) ? "config.xml" : "config.js"
        }
        if (!params.configFileUrl) {
            params.configFileUrl = false
        }
        var checkTargetDivInterval;
        var target = params.target;
        var targetDiv;
        var clickpane;
        var buttonPlay;
        var zoomBar;
		var buttonShow;//
        var ylink;
        var path = params.path;
        var configFile = params.configFile;
        var configFileUrl = params.configFileUrl;
        var productId = params.id;
        var pathToConfig;
        var preloader;
        var logger = new YLogger();
        var log = function (msg) {
            logger.logPrefix(msg, path + "@" + target)
        };
        var images = new Array();
        var imagesGrid = new Array();
        var imagesToLoad = 0;
        var loadedImagesCount = 0;
        var settings;
        var dx = 1;
        var dy = 0;
        var isRotating = false;
        var firstImageId = 0;
        var rotateImages = new Array();
        var lastImgH;
        var newImgH;
        var hSteps;
        var lastImgV;
        var newImgV;
        var vSteps;
        var previousImage = false;
        var currentImage;
        var rotateInterval;
        var rotateIntervalDuration = 50;
        var lastPointerX = 0;
        var startPointerX = 0;
        var lastPointerY = 0;
        var startPointerY = 0;
        var wasRotating = true;
        var isMouseDown = false;
        var scaleRatioDefault;
        var scaleActual = 1;
        var scaleStart = 1;
        var scaleEnd = 1;
        var scaleRatioMax = 2;
        var scaleMax = 200;
        var initWidth;
        var initHeight;
        var targetWidth;
        var targetHeight;
        var isGesutre;
        var wasGesture;
        var isPan;
        var wasPan;
        var startLeft;
        var startTop;
        var currenImageOffsetX;
        var currenImageOffsetY;
        var currenImageRelativeX;
        var currenImageRelativeY;
        var previousImageWidth;
        var previousImageHeight;
        var lt = "ff";
        var settingsParsed = false;
        var rotateOnceCounter = 0;
        this.isXMLLoaded = false;
        var xmlLoader = new XMLLoader();
        this.getPathToConfig = function () {
            return pathToConfig
        };
        if (path.length > 0) {
            var pathLastChar = path.substr(path.length - 1);
            if (pathLastChar == "/" || pathLastChar == "\\") {} else {
                path = path + "/"
            }
        } else {
            path = ""
        } if (configFileUrl) {
            pathToConfig = configFileUrl
        } else {
            pathToConfig = path + configFile
        }
        rlog("Checking target div: " + params.target);
        checkTargetDivInterval = setInterval(function () {
            if (document.getElementById(params.target)) {
                targetDivLoaded();
                clearInterval(checkTargetDivInterval)
            }
        }, 100);
        var targetDivLoaded = function () {
            rlog('TargetDiv: "' + params.target + '" is loaded');
            targetDiv = document.getElementById(params.target);
            if (params.targetWidth > 0 && params.targetHeight > 0) {
                targetWidth = params.targetWidth - 2;
                targetHeight = params.targetHeight - 2;
                targetDiv.style.width = params.targetWidth + "px";
                targetDiv.style.height = params.targetHeight + "px"
            } else {
                if (targetDiv.offsetWidth == 0 || targetDiv.offsetHeight == 0) {
                    alert("RotateTool: Target size not defined!")
                } else {
                    targetWidth = targetDiv.offsetWidth;
                    targetHeight = targetDiv.offsetHeight;
                }
            }
            targetDiv.innerHTML = "";
            targetDiv.style.overflow = "hidden";
            targetDiv.style.position = "relative";
            loadSettings()
        };
        var loadScript = function (sScriptSrc, oCallback) {
            var oHead = document.getElementsByTagName("head")[0];
            var oScript = document.createElement("script");
            oScript.type = "text/javascript";
            oScript.src = sScriptSrc;
            oScript.onload = oCallback;
            oScript.onreadystatechange = function () {
                rlog("...onreadystatechange");
                if (this.readyState == "complete" || this.readyState == "loaded") {
                    oCallback()
                }
            };
            oHead.appendChild(oScript)
        };
        this.xmlLoaded = function (xmldoc) {
            this.isXMLLoaded = "true";
            clearTimeout(xmlTimeout);
            var settingsNode = xmldoc.getElementsByTagName("settings")[0];
            settings = new Settings(settingsNode);
            var imagesNode = xmldoc.getElementsByTagName("images")[0];
            if (imagesNode.getElementsByTagName("image").length == 0) {
                imagesNode = xmldoc.getElementsByTagName("images")[1]
            }
            var imageNodes = imagesNode.getElementsByTagName("image");
            imagesToLoad = imageNodes.length;
            hSteps = imagesToLoad;
            vSteps = 1;
            try {
                var multi = xmldoc.getElementsByTagName("multiDirectional")[0];
                vSteps = multi.getAttribute("verticalSteps")
            } catch (err) {}
            hSteps = imagesToLoad / vSteps;
            initRotation(imageNodes, hSteps, vSteps, imagesToLoad)
        };
        var loadSettings = function () {
            var url = pathToConfig;
            rlog("Loading settings: " + url);
            if (params.xml) {
                xmlLoader.loadXML(pathToConfig, target, true);
                xmlTimeout = setTimeout('RotateTool.checkXMLLoad("' + target + '")', 5000)
            } else {
                loadScript(url, parseDataFile)
            }
        };
        this.showNextImage = function () {
            newImgH = lastImgH + dx;
            newImgV = lastImgV + dy;
            if (newImgH >= hSteps) {
                newImgH = 0
            }
            if (newImgH < 0) {
                newImgH = hSteps - 1
            }
            if (newImgV >= vSteps) {
                newImgV = vSteps - 1
            }
            if (newImgV < 0) {
                newImgV = 0
            }
            try {
                rotateImages[imagesGrid[lastImgV][lastImgH]].style.display = "none";
                rotateImages[imagesGrid[newImgV][newImgH]].style.display = "block";
                currentImage = rotateImages[imagesGrid[newImgV][newImgH]];
                setScale(100, rotateImages[imagesGrid[newImgV][newImgH]])
            } catch (err) {}
            lastImgH = newImgH;
            lastImgV = newImgV;
            if (settings.rotation.rotateOnce) {
                rotateOnceCounter++;
                if (rotateOnceCounter == (hSteps + 1)) {
                    stopRotation()
                }
            }
        };
        var parseDataFileIE = function () {
            if (this.readyState == "complete") {
                parseDataFile()
            }
        };
		
        var parseDataFile = function () {
            rlog("Settings are loaded...");
            if (settingsParsed) {
                return
            }
            var jsonData;
            try {
				//alert('in try');
                jsonData = eval("RotationData_" + productId)
            } catch (err) {
                try {
					//alert('in try try');
                    jsonData = eval("RotationData")
                } catch (err2) {
                    alert("3DRT: Error evaluating config.js!");
                    return false
                }
            }
            if (jsonData == undefined) {
               // alert("3DRT: Error accessing settings in config.js!");
                return false
            }
			//alert('above rlog jsonData'+jsonData);
            rlog(jsonData);
            settings = {};
            settings.rotation = {
                rotatePeriod: jsonData.settings.rotation.rotatePeriod,
                rotateOnStart: jsonData.settings.rotation.rotate == "true",
                rotateOnce: jsonData.settings.rotation.rotate == "once"
            };
            settings.userInterface = {
                showTogglePlayButton: jsonData.settings.userInterface.showTogglePlayButton,
                showZoombar: jsonData.settings.userInterface.showZoombar,
				showButton: jsonData.settings.userInterface.showButton
            };
			
            imagesToLoad = jsonData.images.length;
            hSteps = imagesToLoad;//tot image
            vSteps = 1;
            if (loadedImagesCount > 0 && loadedImagesCount == imagesToLoad) {
                return
            }
            try {
                vSteps = jsonData.settings.rotation.multilevel.verticalSteps
            } catch (err) {}
            hSteps = imagesToLoad / vSteps;
            var imageNodes = jsonData.images;
            initRotation(imageNodes, hSteps, vSteps, imagesToLoad)
        };

        function initRotation(imageNodes, hSteps, vSteps, imagesToLoad) {
			//alert('in initRotation');
            preloader = new YPreloader(targetDiv);
            var actualVStep = 0;
            if (lt == "pp" || lt == "ff") {
                addYLink()
            }
            if (lt == "ff") {
                addCopyright()
            }
            for (var i = 0; i < imagesToLoad; i++) {
                var imagePath;
                var imagePathLarge;
                if (params.xml) {
                    imagePath = path + imageNodes[i].getAttribute("src");
                    imagePathLarge = (imageNodes[i].getAttribute("srcLarge")) ? (path + imageNodes[i].getAttribute("srcLarge")) : false
                } else {
                    imagePath = path + imageNodes[i].src;
                    imagePathLarge = (imageNodes[i].srcLarge) ? (path + imageNodes[i].srcLarge) : false
                }
                var image = document.createElement("img");
                image.id = i;
                if (images[actualVStep] == undefined) {
                    images[actualVStep] = new Array()
                }
                if (imagesGrid[actualVStep] == undefined) {
                    imagesGrid[actualVStep] = new Array()
                }
                images[actualVStep].push(image);
                imagesGrid[actualVStep].push(i);
                image.onload = imageLoaded;
                image.onerror = imageError;
                image.src = imagePath;
                image.srcNormal = imagePath;
                image.srcLarge = imagePathLarge;
                //image.style.display = "none";
                if ((i + 1) % hSteps == 0) {
                    actualVStep++
                }
            }
            settingsParsed = true
        }
        var imageError = function (e) {
            rlog("Error loading image: " + this.src);
            loadedImagesCount++
        };
        var imageLoaded = function () {
            var scaleRatio = 1;
            var imageWidth = this.width;
            var imageHeight = this.height;
            var targetRatio = targetWidth / targetHeight;
            var imageRatio = imageWidth / imageHeight;
            if (targetRatio < imageRatio) {
                scaleRatio = targetWidth / imageWidth
            } else {
                scaleRatio = targetHeight / imageHeight
            }
            var newHeight;
            var newWidth;
            newHeight = Math.floor(this.height * scaleRatio);
            newWidth = Math.floor(this.width * scaleRatio);
            this.height = newHeight;
            this.width = newWidth;
            initWidth = newWidth;
            initHeight = newHeight;
            this.style.position = "relative";
            this.style.cursor = "pointer";
            this.style.zIndex = 10;
            rotateImages[this.id] = this;
            targetDiv.appendChild(this);
            setScale(100, this);
            loadedImagesCount++;
            var percent = Math.round((loadedImagesCount / imagesToLoad) * 100);
            if (preloader && preloader.update) {
                preloader.update(percent)
            }
            if (imagesToLoad > 0 && imagesToLoad == loadedImagesCount) {
                scaleActual = 1;
                if (preloader && preloader.destroy) {
                    preloader.destroy()
                }
                imagesLoaded()
            }
        };
        var imagesLoaded = function () {
            rlog("All images are loaded...");
            if (lt == "ff") {
                if (ylink) {
                    ylink.style.display = "block"
                }
            } else {
                if (ylink) {
                    ylink.style.display = "none"
                }
            }
            rotateIntervalDuration = ((settings.rotation.rotatePeriod * 1000) / hSteps);
            lastImgH = imagesToLoad - 1;
            newImgH = 0;
            lastImgV = 0;
            newImgH = 0;
            clickpane = document.createElement("div");
            clickpane.style.width = targetWidth + "px";
            clickpane.style.height = targetHeight + "px";
            clickpane.style.background = "white";
            clickpane.style.opacity = "0";
            clickpane.style.filter = "alpha(Opacity=0)";
			clickpane.style.display = "block";
            clickpane.style.position = "absolute";
            clickpane.style.left = "0px";
            clickpane.style.top = "0px";
            clickpane.style.cursor = "pointer";
            clickpane.style.zIndex = 90;
            targetDiv.appendChild(clickpane);
            buttonPlay = document.createElement("div");
            buttonPlay.innerHTML = "Play";
            buttonPlay.style.width = "55px";
            buttonPlay.style.height = "25px";
            buttonPlay.style.background = "#EEEEEE";
            buttonPlay.style.fontFamily = "sans-serif";
            buttonPlay.style.fontSize = "14px";
            buttonPlay.style.color = "black";
            buttonPlay.style.fontWeight = "bolder";
            buttonPlay.style.lineHeight = "25px";
            buttonPlay.style.textAlign = "center";
            buttonPlay.style.border = "1px solid black";
            buttonPlay.style.opacity = "0.8";
            buttonPlay.style.filter = "alpha(Opacity=80)";
            buttonPlay.style.display = "block";
            buttonPlay.style.position = "absolute";
            buttonPlay.style.left = "15px";
            buttonPlay.style.top = targetHeight - 35 + "px";
            buttonPlay.style.cursor = "pointer";
            buttonPlay.style.zIndex = 395;
            targetDiv.appendChild(buttonPlay);
            try {
                zoomBar = document.createElement("input");
                zoomBar.type = "range";
                zoomBar.min = 100;
                zoomBar.max = 300;
                zoomBar.value = 100;
                zoomBar.step = 1;
                zoomBar.style.position = "absolute";
                zoomBar.style.left = "80px";
                zoomBar.style.top = targetHeight - 35 + "px";
                zoomBar.style.zIndex = 105;
                zoomBar.addEventListener("change", zoomBarListener);
                targetDiv.appendChild(zoomBar)
				//
				/*buttonShow = document.createElement("input");
				buttonShow.type = "button";
				buttonShow.value = " Show ";
				buttonShow.title = " With Label";
				buttonShow.style.opacity = 0.8;
				buttonShow.style.border = 1+"px solid black";
				buttonShow.style.padding = 3+"px";
				buttonShow.style.fontweight = "bolder";
                buttonShow.style.position = "absolute";
				buttonShow.style.left = "220px";
                buttonShow.style.top = targetHeight - 35 + "px";
                buttonShow.style.zIndex = 105;
                targetDiv.appendChild(buttonShow)*/
				//
            } catch (err) {}
            if (DeviceDetector.isTouchDevice) {
                buttonPlay.addEventListener("touchend", buttonPlayClick, false);
                clickpane.addEventListener("gesturestart", gestureStart, false);
                clickpane.addEventListener("gesturechange", gestureChange, false);
                clickpane.addEventListener("gestureend", gestureEnd, false);
                clickpane.addEventListener("touchstart", touchStartNew, false);
                clickpane.addEventListener("touchend", touchEndNew, false);
                clickpane.addEventListener("touchmove", touchMoveNew, false)
            } else {
                YAHOO.util.Event.addListener(clickpane, "mousedown", onMouseDown);
                YAHOO.util.Event.addListener(buttonPlay, "click", buttonPlayClick);
				YAHOO.util.Event.addListener(buttonShow, "click", onclick)// 
            } if (navigator.userAgent.indexOf("Firefox") != -1) {
                zoomBar.style.display = "none"
            }
            buttonPlay.style.visibility = (settings.userInterface.showTogglePlayButton == true) ? "visible" : "hidden";
            zoomBar.style.visibility = (settings.userInterface.showZoombar == true) ? "visible" : "hidden";
			// show button code here 
            if (settings.rotation.rotateOnStart || settings.rotation.rotateOnce) {
                startRotation()
            } else {
                eval('RotateTool.rotate("' + target + '")')
            }
        };
        var setScale = function (value, image) {
            scaleActual = value / 100;
            var newWidth = initWidth * scaleActual;
            var newHeight = initHeight * scaleActual;
            image.width = newWidth;
            image.height = newHeight;
            var offsetX, offsetY;
            if (newWidth <= targetWidth) {
                offsetX = 0.5 * (targetWidth - newWidth);
                image.style.left = "" + offsetX + "px"
            } else {
                offsetX = 0.5 * (newWidth - targetWidth);
                image.style.left = "-" + offsetX + "px"
            } if (newHeight <= targetHeight) {
                offsetY = 0.5 * (targetHeight - newHeight);
                image.style.top = "" + offsetY + "px"
            } else {
                offsetY = 0.5 * (newHeight - targetHeight);
                image.style.top = "-" + offsetY + "px"
            } if (value > 100) {
                offsetX = -currenImageRelativeX * newWidth + targetWidth * 0.5;
                offsetY = -currenImageRelativeY * newHeight + targetHeight * 0.5;
                image.style.top = "" + offsetY + "px";
                image.style.left = "" + offsetX + "px";
                if (image.srcLarge) {
                    image.onload = undefined;
                    image.src = image.srcLarge
                }
            } else {
                scaleEnd = 1;
                currenImageRelativeX = 0.5;
                currenImageRelativeY = 0.5;
                if (image.src == image.srcLarge) {
                    image.src = image.srcNormal
                }
            }
        };
        var startRotation = function () {
            if (rotateInterval) {
                clearInterval(rotateInterval)
            }
            rotateInterval = setInterval('RotateTool.rotate("' + target + '")', rotateIntervalDuration);
            isRotating = true;
            buttonPlay.innerHTML = "Pause"
        };
        var stopRotation = function () {
            clearInterval(rotateInterval);
            isRotating = false;
            settings.rotation.rotateOnce = false;
            if (!isMouseDown) {
                buttonPlay.innerHTML = "Play"
            }
        };
        var addYLink = function () {
            ylink = document.createElement("div");
            ylink.style.width = "120px";
            ylink.style.height = "25px";
            ylink.style.fontFamily = "sans-serif";
            ylink.style.fontSize = "14px";
            ylink.style.fontWeight = "normal";
            ylink.style.lineHeight = "25px";
            ylink.style.textAlign = "left";
            ylink.style.position = "absolute";
            ylink.style.left = targetWidth - 80 + "px";
            ylink.style.top = targetHeight - 27 + "px";
            ylink.style.zIndex = 195;
            targetDiv.appendChild(ylink)
        };
        var addCopyright = function () {
            var logo = document.createElement("div");
            logo.style.position = "absolute";
            logo.style.fontSize = "20px";
            logo.style.fontWeight = "bolder";
            logo.style.fontFamily = "verdana, arial, sans-serif";
            logo.style.marginTop = "3px";
            logo.style.marginLeft = "3px";
            logo.style.top = 0;
            logo.style.left = 0;
            logo.style.zIndex = 80;
            logo.style.textAlign = "center";
            logo.onmouseover = function () {
                var d = document.getElementById("yoflalink");
                d.style.color = "yellow"
            };
            logo.onmouseout = function () {
                var d = document.getElementById("yoflalink");
                d.style.color = "white"
            };
            targetDiv.appendChild(logo)
        };
        var zoomBarListener = function (e) {
            stopRotation();
            setScale(zoomBar.value, currentImage)
        };
		//vijay
		var onclick = function (e) {
            
			//var divstyle = new String(); 
            //divstyle = document.getElementById('rotateContent').style.visibility;
			
			//if (divstyle.toLowerCase() == "visible" || divstyle == "") { 
                document.getElementById('rotateContent').style.display = "none"; 
				document.getElementById('rotateContent1').style.display = "block"; 
            //} 
			
        };
		
		//vijay
        var onMouseDown = function (e) {
            rlog("Mouse Down");
            isMouseDown = true;
            wasRotating = isRotating;
            stopRotation();
            if (!e) {
                var e = window.event
            }
            startPointerX = e.clientX;
            startPointerY = e.clientY;
            try {
                e.preventDefault()
            } catch (err) {}
            startLeft = parseInt(currentImage.style.left, 10);
            startTop = parseInt(currentImage.style.top, 10);
            YAHOO.util.Event.addListener(clickpane, "mouseup", onMouseUp);
            YAHOO.util.Event.addListener(clickpane, "mousemove", onMouseMove);
            try {
                e.stopEvent()
            } catch (err) {}
        };
        var onMouseUp = function (e) {
            isMouseDown = false;
            YAHOO.util.Event.removeListener(clickpane, "mouseup", onMouseUp);
            YAHOO.util.Event.removeListener(clickpane, "mousemove", onMouseMove);
            if (!e) {
                var e = window.event
            }
            var currentX = e.clientX;
            var dif = startPointerX - currentX;
            if (wasPan) {
                rlog("was pan");
                wasPan = false;
                currenImageOffsetX = (parseInt(currentImage.style.left, 10));
                currenImageOffsetY = (parseInt(currentImage.style.top, 10));
                currenImageRelativeX = (-currenImageOffsetX + targetWidth * 0.5) / currentImage.width;
                currenImageRelativeY = (-currenImageOffsetY + targetHeight * 0.5) / currentImage.height
            } else {
                setEnd = 1;
                setScale(100, currentImage);
                if (zoomBar) {
                    zoomBar.value = 100
                }
                /*if (dif == 0) {
                    if (wasRotating) {
                        stopRotation()
                    } else {
                        //startRotation() code execute when mouse press on object
                    }
                } else {
                    //startRotation()
                }*/
            }
            try {
                e.stopEvent()
            } catch (err) {}
        };
        var onMouseMove = function (e) {
            if (!isMouseDown) {
                return
            }
            if (!e) {
                var e = window.event
            }
            var currentPointerX = e.clientX;
            var currentPointerY = e.clientY;
            rlog("mouse move", scaleStart, scaleActual);
            if (scaleStart != scaleActual) {
                rlog("pan...");
                offsetX = startPointerX - currentPointerX;
                offsetY = startPointerY - currentPointerY;
                var newLeft = startLeft - offsetX;
                var newTop = startTop - offsetY;
                currentImage.style.left = newLeft + "px";
                currentImage.style.top = newTop + "px";
                currenImageOffsetX = parseInt(currentImage.style.left, 10);
                currenImageOffsetY = parseInt(currentImage.style.top, 10);
                wasPan = true
            } else {
                if (currentPointerX > lastPointerX) {
                    dx = -1;
                    eval('window.RotateTool.rotate("' + target + '")')
                } else {
                    if (currentPointerX < lastPointerX) {
                        dx = 1;
                        eval('window.RotateTool.rotate("' + target + '")')
                    } else {
                        dx = 0
                    }
                }
                if (currentPointerY > lastPointerY) {
                    dy = -1;
                    eval('window.RotateTool.rotate("' + target + '")')
                } else {
                    if (currentPointerY < lastPointerY) {
                        dy = 1;
                        eval('window.RotateTool.rotate("' + target + '")')
                    } else {
                        dy = 0
                    }
                }
            }
            lastPointerX = currentPointerX;
            lastPointerY = currentPointerY
        };
        var buttonPlayClick = function (e) {
            try {
                e.preventDefault()
            } catch (err) {}
            if (isRotating) {
                stopRotation()
            } else {
                scaleEnd = 1;
                startRotation()
            }
        };
        var gestureStart = function (e) {
            e.preventDefault();
            scaleStart = e.scale;
            stopRotation();
            isGesutre = true
        };
        var gestureChange = function (e) {
            var value;
            if (e.scale > 1) {
                value = (e.scale - 1) + scaleEnd
            } else {
                value = scaleEnd - 5 * (1 - e.scale)
            } if (value < 1) {
                value = 1
            }
            setScale(value * 100, currentImage);
            e.preventDefault()
        };
        var gestureEnd = function (e) {
            e.preventDefault();
            isGesutre = false;
            scaleEnd = scaleActual;
            wasGesture = true
        };
        var touchStartNew = function (e) {
            e.preventDefault();
            wasRotating = isRotating;
            isMouseDown = true;
            stopRotation();
            startPointerX = event.targetTouches[0].screenX;
            startPointerY = event.targetTouches[0].screenY;
            wasGesture = false;
            wasPan = false;
            startLeft = parseInt(currentImage.style.left, 10);
            startTop = parseInt(currentImage.style.top, 10);
            previousImageWidth = currentImage.width;
            previousImageHeight = currentImage.height
        };
        var touchMoveNew = function (e) {
            e.preventDefault();
            var currentPointerX = event.targetTouches[0].screenX;
            var currentPointerY = event.targetTouches[0].screenY;
            var offsetX, offsetY;
            if (isGesutre || wasGesture || isPan) {
                if (isPan) {
                    offsetX = startPointerX - currentPointerX;
                    offsetY = startPointerY - currentPointerY;
                    var newLeft = startLeft - offsetX;
                    var newTop = startTop - offsetY;
                    currentImage.style.left = newLeft + "px";
                    currentImage.style.top = newTop + "px";
                    currenImageOffsetX = parseInt(currentImage.style.left, 10);
                    currenImageOffsetY = parseInt(currentImage.style.top, 10);
                    wasPan = true
                }
            } else {
                if (scaleActual > 1) {
                    isPan = true
                } else {
                    if (currentPointerX > lastPointerX) {
                        dx = -1;
                        eval('window.RotateTool.rotate("' + target + '")')
                    } else {
                        if (currentPointerX < lastPointerX) {
                            dx = 1;
                            eval('window.RotateTool.rotate("' + target + '")')
                        } else {
                            dx = 0
                        }
                    } if (currentPointerY > lastPointerY) {
                        dy = -1;
                        eval('window.RotateTool.rotate("' + target + '")')
                    } else {
                        if (currentPointerY < lastPointerY) {
                            dy = 1;
                            eval('window.RotateTool.rotate("' + target + '")')
                        } else {
                            dy = 0
                        }
                    }
                }
            }
            lastPointerX = currentPointerX;
            lastPointerY = currentPointerY
        };
        var touchEndNew = function (e) {
            e.preventDefault();
            if (wasGesture || wasPan) {
                isPan = false;
                currenImageOffsetX = (parseInt(currentImage.style.left, 10));
                currenImageOffsetY = (parseInt(currentImage.style.top, 10));
                currenImageRelativeX = (-currenImageOffsetX + targetWidth * 0.5) / currentImage.width;
                currenImageRelativeY = (-currenImageOffsetY + targetHeight * 0.5) / currentImage.height
            } else {
                scaleEnd = 1;
                var currentX = event.changedTouches[0].screenX;
                var dif = startPointerX - currentX;
                isMouseDown = false;
                if (dif == 0) {
                    if (wasRotating) {
                        stopRotation()
                    } else {
                        startRotation()
                    }
                } else {
                    startRotation()
                }
            }
        }
    };
    var Settings = function (settingsXML) {
        var rotation = {
            rotatePeriod: settingsXML.getElementsByTagName("rotation")[0].getAttribute("rotatePeriod"),
            rotateOnStart: settingsXML.getElementsByTagName("rotation")[0].getAttribute("rotate") == "true",
            rotateOnce: settingsXML.getElementsByTagName("rotation")[0].getAttribute("rotate") == "once",
        };
        var userInterface = {
            showTogglePlayButton: settingsXML.getElementsByTagName("userInterface")[0].getAttribute("showTogglePlayButton") == "true",
            showZoombar: settingsXML.getElementsByTagName("userInterface")[0].getAttribute("showZoombar") == "true",
			showButton: settingsXML.getElementsByTagName("userInterface")[0].getAttribute("showButton") == "true"
        };
        return {
            rotation: rotation,
            userInterface: userInterface
        }
    }
}
var RotateTool = new RotateToolManager();

function YLogger() {
    var a;
    var b = function () {
        if (!document.getElementById("yoflalogdiv")) {
            a = document.createElement("div");
            a.setAttribute("id", "yoflalogdiv");
            a.style.fontFamily = "sans-serif, verdana, arial";
            a.style.fontSize = "10px";
            a.style.width = "500px";
            a.style.height = "500px";
            a.style.left = "300px";
            a.style.top = "300px";
            a.style.overflow = "auto";
            a.style.position = "absolute";
            a.style.background = "#FFFF00";
            a.style.border = "1px solid #FF0000";
            a.style.zIndex = 1000;
            a.innerHTML = "Test Div";
            document.body.appendChild(a)
        }
    };
    this.log = function (d) {
        b();
        var c = a.innerHTML.substr(0, 900);
        a.innerHTML = d + "<br>" + c
    };
    this.logPrefix = function (e, d) {
        var c = d + ": " + e;
        this.log(c)
    }
}
var YPreloader = function (b) {
    if (document.getElementById("preloader_" + b.id)) {
        return
    }
    var a = document.createElement("div");
    a.style.fontSize = "20px";
    a.style.color = "#cccccc";
    a.style.fontFamily = "arial, sans-serif";
    a.style.lineHeight = "30px";
    a.style.textAlign = "left";
    a.style.top = "0px";
    a.style.left = "0px";
    a.style.padding = "5px 10px";
    a.style.text-decoration = "italic";
    a.innerHTML = "&nbsp; 0%";
    a.setAttribute("id", "preloader_" + b.id);
    b.appendChild(a);
    this.update = function (c) {
        var d = "&nbsp; loading... &nbsp; ";
        // if (c < 10) {
        //     d = "&nbsp; loading... &nbsp; "
        // }
        a.innerHTML = d + c + "%"
    };
    this.destroy = function () {
        a.innerHTML = "";
        a.style.display = "none";
        b.removeChild(a)
    }
};
var DeviceDetector = function () {
    var a = {};
    a.UA = navigator.userAgent;
    a.Type = false;
    a.Types = ["iPhone", "iPod", "iPad"];
    for (var c = 0; c < a.Types.length; c++) {
        var b = a.Types[c];
        a[b] = !! a.UA.match(new RegExp(b, "i"));
        a.Type = a.Type || a[b]
    }
    return {
        isTouchDevice: a.Type ? true : false
    }
}();
if (typeof YAHOO == "undefined" || !YAHOO) {
    var YAHOO = {}
}
YAHOO.namespace = function () {
    var a = arguments,
        d = null,
        j, k, h;
    for (j = 0; j < a.length; j = j + 1) {
        h = ("" + a[j]).split(".");
        d = YAHOO;
        for (k = (h[0] == "YAHOO") ? 1 : 0; k < h.length; k = k + 1) {
            d[h[k]] = d[h[k]] || {};
            d = d[h[k]]
        }
    }
    return d
};
YAHOO.log = function (g, f, h) {
    var e = YAHOO.widget.Logger;
    if (e && e.log) {
        return e.log(g, f, h)
    } else {
        return false
    }
};
YAHOO.register = function (s, o, p) {
    var b = YAHOO.env.modules,
        r, l, m, n, q;
    if (!b[s]) {
        b[s] = {
            versions: [],
            builds: []
        }
    }
    r = b[s];
    l = p.version;
    m = p.build;
    n = YAHOO.env.listeners;
    r.name = s;
    r.version = l;
    r.build = m;
    r.versions.push(l);
    r.builds.push(m);
    r.mainClass = o;
    for (q = 0; q < n.length; q = q + 1) {
        n[q](r)
    }
    if (o) {
        o.VERSION = l;
        o.BUILD = m
    } else {
        YAHOO.log("mainClass is undefined for module " + s, "warn")
    }
};
YAHOO.env = YAHOO.env || {
    modules: [],
    listeners: []
};
YAHOO.env.getVersion = function (b) {
    return YAHOO.env.modules[b] || null
};
YAHOO.env.parseUA = function (p) {
    var o = function (b) {
        var a = 0;
        return parseFloat(b.replace(/\./g, function () {
            return (a++ == 1) ? "" : "."
        }))
    }, l = navigator,
        m = {
            ie: 0,
            opera: 0,
            gecko: 0,
            webkit: 0,
            chrome: 0,
            mobile: null,
            air: 0,
            ipad: 0,
            iphone: 0,
            ipod: 0,
            ios: null,
            android: 0,
            webos: 0,
            caja: l && l.cajaVersion,
            secure: false,
            os: null
        }, q = p || (navigator && navigator.userAgent),
        n = window && window.location,
        j = n && n.href,
        k;
    m.secure = j && (j.toLowerCase().indexOf("https") === 0);
    if (q) {
        if ((/windows|win32/i).test(q)) {
            m.os = "windows"
        } else {
            if ((/macintosh/i).test(q)) {
                m.os = "macintosh"
            } else {
                if ((/rhino/i).test(q)) {
                    m.os = "rhino"
                }
            }
        } if ((/KHTML/).test(q)) {
            m.webkit = 1
        }
        k = q.match(/AppleWebKit\/([^\s]*)/);
        if (k && k[1]) {
            m.webkit = o(k[1]);
            if (/ Mobile\//.test(q)) {
                m.mobile = "Apple";
                k = q.match(/OS ([^\s]*)/);
                if (k && k[1]) {
                    k = o(k[1].replace("_", "."))
                }
                m.ios = k;
                m.ipad = m.ipod = m.iphone = 0;
                k = q.match(/iPad|iPod|iPhone/);
                if (k && k[0]) {
                    m[k[0].toLowerCase()] = m.ios
                }
            } else {
                k = q.match(/NokiaN[^\/]*|Android \d\.\d|webOS\/\d\.\d/);
                if (k) {
                    m.mobile = k[0]
                }
                if (/webOS/.test(q)) {
                    m.mobile = "WebOS";
                    k = q.match(/webOS\/([^\s]*);/);
                    if (k && k[1]) {
                        m.webos = o(k[1])
                    }
                }
                if (/ Android/.test(q)) {
                    m.mobile = "Android";
                    k = q.match(/Android ([^\s]*);/);
                    if (k && k[1]) {
                        m.android = o(k[1])
                    }
                }
            }
            k = q.match(/Chrome\/([^\s]*)/);
            if (k && k[1]) {
                m.chrome = o(k[1])
            } else {
                k = q.match(/AdobeAIR\/([^\s]*)/);
                if (k) {
                    m.air = k[0]
                }
            }
        }
        if (!m.webkit) {
            k = q.match(/Opera[\s\/]([^\s]*)/);
            if (k && k[1]) {
                m.opera = o(k[1]);
                k = q.match(/Version\/([^\s]*)/);
                if (k && k[1]) {
                    m.opera = o(k[1])
                }
                k = q.match(/Opera Mini[^;]*/);
                if (k) {
                    m.mobile = k[0]
                }
            } else {
                k = q.match(/MSIE\s([^;]*)/);
                if (k && k[1]) {
                    m.ie = o(k[1])
                } else {
                    k = q.match(/Gecko\/([^\s]*)/);
                    if (k) {
                        m.gecko = 1;
                        k = q.match(/rv:([^\s\)]*)/);
                        if (k && k[1]) {
                            m.gecko = o(k[1])
                        }
                    }
                }
            }
        }
    }
    return m
};
YAHOO.env.ua = YAHOO.env.parseUA();
(function () {
    YAHOO.namespace("util", "widget", "example");
    if ("undefined" !== typeof YAHOO_config) {
        var e = YAHOO_config.listener,
            f = YAHOO.env.listeners,
            g = true,
            h;
        if (e) {
            for (h = 0; h < f.length; h++) {
                if (f[h] == e) {
                    g = false;
                    break
                }
            }
            if (g) {
                f.push(e)
            }
        }
    }
})();
YAHOO.lang = YAHOO.lang || {};
(function () {
    var m = YAHOO.lang,
        r = Object.prototype,
        p = "[object Array]",
        k = "[object Function]",
        j = "[object Object]",
        q = [],
        l = {
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#x27;",
            "/": "&#x2F;",
            "`": "&#x60;"
        }, o = ["toString", "valueOf"],
        n = {
            isArray: function (a) {
                return r.toString.apply(a) === p
            },
            isBoolean: function (a) {
                return typeof a === "boolean"
            },
            isFunction: function (a) {
                return (typeof a === "function") || r.toString.apply(a) === k
            },
            isNull: function (a) {
                return a === null
            },
            isNumber: function (a) {
                return typeof a === "number" && isFinite(a)
            },
            isObject: function (a) {
                return (a && (typeof a === "object" || m.isFunction(a))) || false
            },
            isString: function (a) {
                return typeof a === "string"
            },
            isUndefined: function (a) {
                return typeof a === "undefined"
            },
            _IEEnumFix: (YAHOO.env.ua.ie) ? function (b, c) {
                var d, e, a;
                for (d = 0; d < o.length; d = d + 1) {
                    e = o[d];
                    a = c[e];
                    if (m.isFunction(a) && a != r[e]) {
                        b[e] = a
                    }
                }
            } : function () {},
            escapeHTML: function (a) {
                return a.replace(/[&<>"'\/`]/g, function (b) {
                    return l[b]
                })
            },
            extend: function (a, e, b) {
                if (!e || !a) {
                    throw new Error("extend failed, please check that all dependencies are included.")
                }
                var c = function () {}, d;
                c.prototype = e.prototype;
                a.prototype = new c();
                a.prototype.constructor = a;
                a.superclass = e.prototype;
                if (e.prototype.constructor == r.constructor) {
                    e.prototype.constructor = e
                }
                if (b) {
                    for (d in b) {
                        if (m.hasOwnProperty(b, d)) {
                            a.prototype[d] = b[d]
                        }
                    }
                    m._IEEnumFix(a.prototype, b)
                }
            },
            augmentObject: function (f, a) {
                if (!a || !f) {
                    throw new Error("Absorb failed, verify dependencies.")
                }
                var d = arguments,
                    b, e, c = d[2];
                if (c && c !== true) {
                    for (b = 2; b < d.length; b = b + 1) {
                        f[d[b]] = a[d[b]]
                    }
                } else {
                    for (e in a) {
                        if (c || !(e in f)) {
                            f[e] = a[e]
                        }
                    }
                    m._IEEnumFix(f, a)
                }
                return f
            },
            augmentProto: function (a, b) {
                if (!b || !a) {
                    throw new Error("Augment failed, verify dependencies.")
                }
                var d = [a.prototype, b.prototype],
                    c;
                for (c = 2; c < arguments.length; c = c + 1) {
                    d.push(arguments[c])
                }
                m.augmentObject.apply(this, d);
                return a
            },
            dump: function (h, c) {
                var f, d, a = [],
                    s = "{...}",
                    g = "f(){...}",
                    b = ", ",
                    e = " => ";
                if (!m.isObject(h)) {
                    return h + ""
                } else {
                    if (h instanceof Date || ("nodeType" in h && "tagName" in h)) {
                        return h
                    } else {
                        if (m.isFunction(h)) {
                            return g
                        }
                    }
                }
                c = (m.isNumber(c)) ? c : 3;
                if (m.isArray(h)) {
                    a.push("[");
                    for (f = 0, d = h.length; f < d; f = f + 1) {
                        if (m.isObject(h[f])) {
                            a.push((c > 0) ? m.dump(h[f], c - 1) : s)
                        } else {
                            a.push(h[f])
                        }
                        a.push(b)
                    }
                    if (a.length > 1) {
                        a.pop()
                    }
                    a.push("]")
                } else {
                    a.push("{");
                    for (f in h) {
                        if (m.hasOwnProperty(h, f)) {
                            a.push(f + e);
                            if (m.isObject(h[f])) {
                                a.push((c > 0) ? m.dump(h[f], c - 1) : s)
                            } else {
                                a.push(h[f])
                            }
                            a.push(b)
                        }
                    }
                    if (a.length > 1) {
                        a.pop()
                    }
                    a.push("}")
                }
                return a.join("")
            },
            substitute: function (c, b, h, P) {
                var v, H, J, e, s, g, f = [],
                    M, a = c.length,
                    L = "dump",
                    I = " ",
                    K = "{",
                    O = "}",
                    N, d;
                for (;;) {
                    v = c.lastIndexOf(K, a);
                    if (v < 0) {
                        break
                    }
                    H = c.indexOf(O, v);
                    if (v + 1 > H) {
                        break
                    }
                    M = c.substring(v + 1, H);
                    e = M;
                    g = null;
                    J = e.indexOf(I);
                    if (J > -1) {
                        g = e.substring(J + 1);
                        e = e.substring(0, J)
                    }
                    s = b[e];
                    if (h) {
                        s = h(e, s, g)
                    }
                    if (m.isObject(s)) {
                        if (m.isArray(s)) {
                            s = m.dump(s, parseInt(g, 10))
                        } else {
                            g = g || "";
                            N = g.indexOf(L);
                            if (N > -1) {
                                g = g.substring(4)
                            }
                            d = s.toString();
                            if (d === j || N > -1) {
                                s = m.dump(s, parseInt(g, 10))
                            } else {
                                s = d
                            }
                        }
                    } else {
                        if (!m.isString(s) && !m.isNumber(s)) {
                            s = "~-" + f.length + "-~";
                            f[f.length] = M
                        }
                    }
                    c = c.substring(0, v) + s + c.substring(H + 1);
                    if (P === false) {
                        a = v - 1
                    }
                }
                for (v = f.length - 1; v >= 0; v = v - 1) {
                    c = c.replace(new RegExp("~-" + v + "-~"), "{" + f[v] + "}", "g")
                }
                return c
            },
            trim: function (b) {
                try {
                    return b.replace(/^\s+|\s+$/g, "")
                } catch (a) {
                    return b
                }
            },
            merge: function () {
                var d = {}, b = arguments,
                    c = b.length,
                    a;
                for (a = 0; a < c; a = a + 1) {
                    m.augmentObject(d, b[a], true)
                }
                return d
            },
            later: function (h, e, g, c, b) {
                h = h || 0;
                e = e || {};
                var d = g,
                    v = c,
                    a, f;
                if (m.isString(g)) {
                    d = e[g]
                }
                if (!d) {
                    throw new TypeError("method undefined")
                }
                if (!m.isUndefined(c) && !m.isArray(v)) {
                    v = [c]
                }
                a = function () {
                    d.apply(e, v || q)
                };
                f = (b) ? setInterval(a, h) : setTimeout(a, h);
                return {
                    interval: b,
                    cancel: function () {
                        if (this.interval) {
                            clearInterval(f)
                        } else {
                            clearTimeout(f)
                        }
                    }
                }
            },
            isValue: function (a) {
                return (m.isObject(a) || m.isString(a) || m.isNumber(a) || m.isBoolean(a))
            }
        };
    m.hasOwnProperty = (r.hasOwnProperty) ? function (b, a) {
        return b && b.hasOwnProperty && b.hasOwnProperty(a)
    } : function (b, a) {
        return !m.isUndefined(b[a]) && b.constructor.prototype[a] !== b[a]
    };
    n.augmentObject(m, n, true);
    YAHOO.util.Lang = m;
    m.augment = m.augmentProto;
    YAHOO.augment = m.augmentProto;
    YAHOO.extend = m.extend
})();
YAHOO.register("yahoo", YAHOO, {
    version: "2.9.0",
    build: "2800"
});
YAHOO.util.CustomEvent = function (l, m, g, h, k) {
    this.type = l;
    this.scope = m || window;
    this.silent = g;
    this.fireOnce = k;
    this.fired = false;
    this.firedWith = null;
    this.signature = h || YAHOO.util.CustomEvent.LIST;
    this.subscribers = [];
    if (!this.silent) {}
    var j = "_YUICEOnSubscribe";
    if (l !== j) {
        this.subscribeEvent = new YAHOO.util.CustomEvent(j, this, true)
    }
    this.lastError = null
};
YAHOO.util.CustomEvent.LIST = 0;
YAHOO.util.CustomEvent.FLAT = 1;
YAHOO.util.CustomEvent.prototype = {
    subscribe: function (e, h, g) {
        if (!e) {
            throw new Error("Invalid callback for subscriber to '" + this.type + "'")
        }
        if (this.subscribeEvent) {
            this.subscribeEvent.fire(e, h, g)
        }
        var f = new YAHOO.util.Subscriber(e, h, g);
        if (this.fireOnce && this.fired) {
            this.notify(f, this.firedWith)
        } else {
            this.subscribers.push(f)
        }
    },
    unsubscribe: function (l, j) {
        if (!l) {
            return this.unsubscribeAll()
        }
        var k = false;
        for (var g = 0, h = this.subscribers.length; g < h; ++g) {
            var m = this.subscribers[g];
            if (m && m.contains(l, j)) {
                this._delete(g);
                k = true
            }
        }
        return k
    },
    fire: function () {
        this.lastError = null;
        var l = [],
            k = this.subscribers.length;
        var p = [].slice.call(arguments, 0),
            q = true,
            n, j = false;
        if (this.fireOnce) {
            if (this.fired) {
                return true
            } else {
                this.firedWith = p
            }
        }
        this.fired = true;
        if (!k && this.silent) {
            return true
        }
        if (!this.silent) {}
        var o = this.subscribers.slice();
        for (n = 0; n < k; ++n) {
            var m = o[n];
            if (!m || !m.fn) {
                j = true
            } else {
                q = this.notify(m, p);
                if (false === q) {
                    if (!this.silent) {}
                    break
                }
            }
        }
        return (q !== false)
    },
    notify: function (m, p) {
        var e, k = null,
            n = m.getScope(this.scope),
            j = YAHOO.util.Event.throwErrors;
        if (!this.silent) {}
        if (this.signature == YAHOO.util.CustomEvent.FLAT) {
            if (p.length > 0) {
                k = p[0]
            }
            try {
                e = m.fn.call(n, k, m.obj)
            } catch (l) {
                this.lastError = l;
                if (j) {
                    throw l
                }
            }
        } else {
            try {
                e = m.fn.call(n, this.type, p, m.obj)
            } catch (o) {
                this.lastError = o;
                if (j) {
                    throw o
                }
            }
        }
        return e
    },
    unsubscribeAll: function () {
        var d = this.subscribers.length,
            c;
        for (c = d - 1; c > -1; c--) {
            this._delete(c)
        }
        this.subscribers = [];
        return d
    },
    _delete: function (d) {
        var c = this.subscribers[d];
        if (c) {
            delete c.fn;
            delete c.obj
        }
        this.subscribers.splice(d, 1)
    },
    toString: function () {
        return "CustomEvent: '" + this.type + "', context: " + this.scope
    }
};
YAHOO.util.Subscriber = function (e, d, f) {
    this.fn = e;
    this.obj = YAHOO.lang.isUndefined(d) ? null : d;
    this.overrideContext = f
};
YAHOO.util.Subscriber.prototype.getScope = function (b) {
    if (this.overrideContext) {
        if (this.overrideContext === true) {
            return this.obj
        } else {
            return this.overrideContext
        }
    }
    return b
};
YAHOO.util.Subscriber.prototype.contains = function (d, c) {
    if (c) {
        return (this.fn == d && this.obj == c)
    } else {
        return (this.fn == d)
    }
};
YAHOO.util.Subscriber.prototype.toString = function () {
    return "Subscriber { obj: " + this.obj + ", overrideContext: " + (this.overrideContext || "no") + " }"
};
if (!YAHOO.util.Event) {
    YAHOO.util.Event = function () {
        var n = false,
            m = [],
            k = [],
            t = 0,
            p = [],
            s = 0,
            r = {
                63232: 38,
                63233: 40,
                63234: 37,
                63235: 39,
                63276: 33,
                63277: 34,
                25: 9
            }, q = YAHOO.env.ua.ie,
            o = "focusin",
            l = "focusout";
        return {
            POLL_RETRYS: 500,
            POLL_INTERVAL: 40,
            EL: 0,
            TYPE: 1,
            FN: 2,
            WFN: 3,
            UNLOAD_OBJ: 3,
            ADJ_SCOPE: 4,
            OBJ: 5,
            OVERRIDE: 6,
            CAPTURE: 7,
            lastError: null,
            isSafari: YAHOO.env.ua.webkit,
            webkit: YAHOO.env.ua.webkit,
            isIE: q,
            _interval: null,
            _dri: null,
            _specialTypes: {
                focusin: (q ? "focusin" : "focus"),
                focusout: (q ? "focusout" : "blur")
            },
            DOMReady: false,
            throwErrors: false,
            startInterval: function () {
                if (!this._interval) {
                    this._interval = YAHOO.lang.later(this.POLL_INTERVAL, this, this._tryPreloadAttach, null, true)
                }
            },
            onAvailable: function (d, a, f, e, g) {
                var c = (YAHOO.lang.isString(d)) ? [d] : d;
                for (var b = 0; b < c.length; b = b + 1) {
                    p.push({
                        id: c[b],
                        fn: a,
                        obj: f,
                        overrideContext: e,
                        checkReady: g
                    })
                }
                t = this.POLL_RETRYS;
                this.startInterval()
            },
            onContentReady: function (d, c, b, a) {
                this.onAvailable(d, c, b, a, true)
            },
            onDOMReady: function () {
                this.DOMReadyEvent.subscribe.apply(this.DOMReadyEvent, arguments)
            },
            _addListener: function (f, h, B, c, D, j) {
                if (!B || !B.call) {
                    return false
                }
                if (this._isValidCollection(f)) {
                    var A = true;
                    for (var b = 0, E = f.length; b < E; ++b) {
                        A = this.on(f[b], h, B, c, D) && A
                    }
                    return A
                } else {
                    if (YAHOO.lang.isString(f)) {
                        var d = this.getEl(f);
                        if (d) {
                            f = d
                        } else {
                            this.onAvailable(f, function () {
                                YAHOO.util.Event._addListener(f, h, B, c, D, j)
                            });
                            return true
                        }
                    }
                } if (!f) {
                    return false
                }
                if ("unload" == h && c !== this) {
                    k[k.length] = [f, h, B, c, D];
                    return true
                }
                var g = f;
                if (D) {
                    if (D === true) {
                        g = c
                    } else {
                        g = D
                    }
                }
                var e = function (u) {
                    return B.call(g, YAHOO.util.Event.getEvent(u, f), c)
                };
                var z = [f, h, B, e, g, c, D, j];
                var a = m.length;
                m[a] = z;
                try {
                    this._simpleAdd(f, h, e, j)
                } catch (C) {
                    this.lastError = C;
                    this.removeListener(f, h, B);
                    return false
                }
                return true
            },
            _getType: function (a) {
                return this._specialTypes[a] || a
            },
            addListener: function (a, d, b, f, e) {
                var c = ((d == o || d == l) && !YAHOO.env.ua.ie) ? true : false;
                return this._addListener(a, this._getType(d), b, f, e, c)
            },
            addFocusListener: function (b, c, a, d) {
                return this.on(b, o, c, a, d)
            },
            removeFocusListener: function (a, b) {
                return this.removeListener(a, o, b)
            },
            addBlurListener: function (b, c, a, d) {
                return this.on(b, l, c, a, d)
            },
            removeBlurListener: function (a, b) {
                return this.removeListener(a, l, b)
            },
            removeListener: function (g, h, a) {
                var f, c, j;
                h = this._getType(h);
                if (typeof g == "string") {
                    g = this.getEl(g)
                } else {
                    if (this._isValidCollection(g)) {
                        var w = true;
                        for (f = g.length - 1; f > -1; f--) {
                            w = (this.removeListener(g[f], h, a) && w)
                        }
                        return w
                    }
                } if (!a || !a.call) {
                    return this.purgeElement(g, false, h)
                }
                if ("unload" == h) {
                    for (f = k.length - 1; f > -1; f--) {
                        j = k[f];
                        if (j && j[0] == g && j[1] == h && j[2] == a) {
                            k.splice(f, 1);
                            return true
                        }
                    }
                    return false
                }
                var e = null;
                var d = arguments[3];
                if ("undefined" === typeof d) {
                    d = this._getCacheIndex(m, g, h, a)
                }
                if (d >= 0) {
                    e = m[d]
                }
                if (!g || !e) {
                    return false
                }
                var v = e[this.CAPTURE] === true ? true : false;
                try {
                    this._simpleRemove(g, h, e[this.WFN], v)
                } catch (b) {
                    this.lastError = b;
                    return false
                }
                delete m[d][this.WFN];
                delete m[d][this.FN];
                m.splice(d, 1);
                return true
            },
            getTarget: function (a, b) {
                var c = a.target || a.srcElement;
                return this.resolveTextNode(c)
            },
            resolveTextNode: function (a) {
                try {
                    if (a && 3 == a.nodeType) {
                        return a.parentNode
                    }
                } catch (b) {
                    return null
                }
                return a
            },
            getPageX: function (a) {
                var b = a.pageX;
                if (!b && 0 !== b) {
                    b = a.clientX || 0;
                    if (this.isIE) {
                        b += this._getScrollLeft()
                    }
                }
                return b
            },
            getPageY: function (b) {
                var a = b.pageY;
                if (!a && 0 !== a) {
                    a = b.clientY || 0;
                    if (this.isIE) {
                        a += this._getScrollTop()
                    }
                }
                return a
            },
            getXY: function (a) {
                return [this.getPageX(a), this.getPageY(a)]
            },
            getRelatedTarget: function (a) {
                var b = a.relatedTarget;
                if (!b) {
                    if (a.type == "mouseout") {
                        b = a.toElement
                    } else {
                        if (a.type == "mouseover") {
                            b = a.fromElement
                        }
                    }
                }
                return this.resolveTextNode(b)
            },
            getTime: function (a) {
                if (!a.time) {
                    var b = new Date().getTime();
                    try {
                        a.time = b
                    } catch (c) {
                        this.lastError = c;
                        return b
                    }
                }
                return a.time
            },
            stopEvent: function (a) {
                this.stopPropagation(a);
                this.preventDefault(a)
            },
            stopPropagation: function (a) {
                if (a.stopPropagation) {
                    a.stopPropagation()
                } else {
                    a.cancelBubble = true
                }
            },
            preventDefault: function (a) {
                if (a.preventDefault) {
                    a.preventDefault()
                } else {
                    a.returnValue = false
                }
            },
            getEvent: function (a, c) {
                var b = a || window.event;
                if (!b) {
                    var d = this.getEvent.caller;
                    while (d) {
                        b = d.arguments[0];
                        if (b && Event == b.constructor) {
                            break
                        }
                        d = d.caller
                    }
                }
                return b
            },
            getCharCode: function (a) {
                var b = a.keyCode || a.charCode || 0;
                if (YAHOO.env.ua.webkit && (b in r)) {
                    b = r[b]
                }
                return b
            },
            _getCacheIndex: function (g, d, c, e) {
                for (var f = 0, a = g.length; f < a; f = f + 1) {
                    var b = g[f];
                    if (b && b[this.FN] == e && b[this.EL] == d && b[this.TYPE] == c) {
                        return f
                    }
                }
                return -1
            },
            generateId: function (b) {
                var a = b.id;
                if (!a) {
                    a = "yuievtautoid-" + s;
                    ++s;
                    b.id = a
                }
                return a
            },
            _isValidCollection: function (a) {
                try {
                    return (a && typeof a !== "string" && a.length && !a.tagName && !a.alert && typeof a[0] !== "undefined")
                } catch (b) {
                    return false
                }
            },
            elCache: {},
            getEl: function (a) {
                return (typeof a === "string") ? document.getElementById(a) : a
            },
            clearCache: function () {},
            DOMReadyEvent: new YAHOO.util.CustomEvent("DOMReady", YAHOO, 0, 0, 1),
            _load: function (a) {
                if (!n) {
                    n = true;
                    var b = YAHOO.util.Event;
                    b._ready();
                    b._tryPreloadAttach()
                }
            },
            _ready: function (a) {
                var b = YAHOO.util.Event;
                if (!b.DOMReady) {
                    b.DOMReady = true;
                    b.DOMReadyEvent.fire();
                    b._simpleRemove(document, "DOMContentLoaded", b._ready)
                }
            },
            _tryPreloadAttach: function () {
                if (p.length === 0) {
                    t = 0;
                    if (this._interval) {
                        this._interval.cancel();
                        this._interval = null
                    }
                    return
                }
                if (this.locked) {
                    return
                }
                if (this.isIE) {
                    if (!this.DOMReady) {
                        this.startInterval();
                        return
                    }
                }
                this.locked = true;
                var e = !n;
                if (!e) {
                    e = (t > 0 && p.length > 0)
                }
                var f = [];
                var d = function (v, j) {
                    var w = v;
                    if (j.overrideContext) {
                        if (j.overrideContext === true) {
                            w = j.obj
                        } else {
                            w = j.overrideContext
                        }
                    }
                    j.fn.call(w, j.obj)
                };
                var b, c, g, h, a = [];
                for (b = 0, c = p.length; b < c; b = b + 1) {
                    g = p[b];
                    if (g) {
                        h = this.getEl(g.id);
                        if (h) {
                            if (g.checkReady) {
                                if (n || h.nextSibling || !e) {
                                    a.push(g);
                                    p[b] = null
                                }
                            } else {
                                d(h, g);
                                p[b] = null
                            }
                        } else {
                            f.push(g)
                        }
                    }
                }
                for (b = 0, c = a.length; b < c; b = b + 1) {
                    g = a[b];
                    d(this.getEl(g.id), g)
                }
                t--;
                if (e) {
                    for (b = p.length - 1; b > -1; b--) {
                        g = p[b];
                        if (!g || !g.id) {
                            p.splice(b, 1)
                        }
                    }
                    this.startInterval()
                } else {
                    if (this._interval) {
                        this._interval.cancel();
                        this._interval = null
                    }
                }
                this.locked = false
            },
            purgeElement: function (f, e, c) {
                var h = (YAHOO.lang.isString(f)) ? this.getEl(f) : f;
                var d = this.getListeners(h, c),
                    g, b;
                if (d) {
                    for (g = d.length - 1; g > -1; g--) {
                        var a = d[g];
                        this.removeListener(h, a.type, a.fn)
                    }
                }
                if (e && h && h.childNodes) {
                    for (g = 0, b = h.childNodes.length; g < b; ++g) {
                        this.purgeElement(h.childNodes[g], e, c)
                    }
                }
            },
            getListeners: function (e, g) {
                var b = [],
                    f;
                if (!g) {
                    f = [m, k]
                } else {
                    if (g === "unload") {
                        f = [k]
                    } else {
                        g = this._getType(g);
                        f = [m]
                    }
                }
                var v = (YAHOO.lang.isString(e)) ? this.getEl(e) : e;
                for (var c = 0; c < f.length; c = c + 1) {
                    var h = f[c];
                    if (h) {
                        for (var a = 0, j = h.length; a < j; ++a) {
                            var d = h[a];
                            if (d && d[this.EL] === v && (!g || g === d[this.TYPE])) {
                                b.push({
                                    type: d[this.TYPE],
                                    fn: d[this.FN],
                                    obj: d[this.OBJ],
                                    adjust: d[this.OVERRIDE],
                                    scope: d[this.ADJ_SCOPE],
                                    index: a
                                })
                            }
                        }
                    }
                }
                return (b.length) ? b : null
            },
            _unload: function (z) {
                var f = YAHOO.util.Event,
                    c, d, e, a, b, y = k.slice(),
                    g;
                for (c = 0, a = k.length; c < a; ++c) {
                    e = y[c];
                    if (e) {
                        try {
                            g = window;
                            if (e[f.ADJ_SCOPE]) {
                                if (e[f.ADJ_SCOPE] === true) {
                                    g = e[f.UNLOAD_OBJ]
                                } else {
                                    g = e[f.ADJ_SCOPE]
                                }
                            }
                            e[f.FN].call(g, f.getEvent(z, e[f.EL]), e[f.UNLOAD_OBJ])
                        } catch (h) {}
                        y[c] = null
                    }
                }
                e = null;
                g = null;
                k = null;
                if (m) {
                    for (d = m.length - 1; d > -1; d--) {
                        e = m[d];
                        if (e) {
                            try {
                                f.removeListener(e[f.EL], e[f.TYPE], e[f.FN], d)
                            } catch (j) {}
                        }
                    }
                    e = null
                }
                try {
                    f._simpleRemove(window, "unload", f._unload);
                    f._simpleRemove(window, "load", f._load)
                } catch (x) {}
            },
            _getScrollLeft: function () {
                return this._getScroll()[1]
            },
            _getScrollTop: function () {
                return this._getScroll()[0]
            },
            _getScroll: function () {
                var b = document.documentElement,
                    a = document.body;
                if (b && (b.scrollTop || b.scrollLeft)) {
                    return [b.scrollTop, b.scrollLeft]
                } else {
                    if (a) {
                        return [a.scrollTop, a.scrollLeft]
                    } else {
                        return [0, 0]
                    }
                }
            },
            regCE: function () {},
            _simpleAdd: function () {
                if (window.addEventListener) {
                    return function (a, d, b, c) {
                        a.addEventListener(d, b, (c))
                    }
                } else {
                    if (window.attachEvent) {
                        return function (a, d, b, c) {
                            a.attachEvent("on" + d, b)
                        }
                    } else {
                        return function () {}
                    }
                }
            }(),
            _simpleRemove: function () {
                if (window.removeEventListener) {
                    return function (a, d, b, c) {
                        a.removeEventListener(d, b, (c))
                    }
                } else {
                    if (window.detachEvent) {
                        return function (b, a, c) {
                            b.detachEvent("on" + a, c)
                        }
                    } else {
                        return function () {}
                    }
                }
            }()
        }
    }();
    (function () {
        var d = YAHOO.util.Event;
        d.on = d.addListener;
        d.onFocus = d.addFocusListener;
        d.onBlur = d.addBlurListener;

        if (d.isIE) {
            if (self !== self.top) {
                document.onreadystatechange = function () {
                    if (document.readyState == "complete") {
                        document.onreadystatechange = null;
                        d._ready()
                    }
                }
            } else {
                YAHOO.util.Event.onDOMReady(YAHOO.util.Event._tryPreloadAttach, YAHOO.util.Event, true);
                var c = document.createElement("p");
                d._dri = setInterval(function () {
                    try {
                        c.doScroll("left");
                        clearInterval(d._dri);
                        d._dri = null;
                        d._ready();
                        c = null
                    } catch (a) {}
                }, d.POLL_INTERVAL)
            }
        } else {
            if (d.webkit && d.webkit < 525) {
                d._dri = setInterval(function () {
                    var a = document.readyState;
                    if ("loaded" == a || "complete" == a) {
                        clearInterval(d._dri);
                        d._dri = null;
                        d._ready()
                    }
                }, d.POLL_INTERVAL)
            } else {
                d._simpleAdd(document, "DOMContentLoaded", d._ready)
            }
        }
        d._simpleAdd(window, "load", d._load);
        d._simpleAdd(window, "unload", d._unload);
        d._tryPreloadAttach()
    })()
}
YAHOO.util.EventProvider = function () {};
YAHOO.util.EventProvider.prototype = {
    __yui_events: null,
    __yui_subscribers: null,
    subscribe: function (h, m, j, k) {
        this.__yui_events = this.__yui_events || {};
        var l = this.__yui_events[h];
        if (l) {
            l.subscribe(m, j, k)
        } else {
            this.__yui_subscribers = this.__yui_subscribers || {};
            var g = this.__yui_subscribers;
            if (!g[h]) {
                g[h] = []
            }
            g[h].push({
                fn: m,
                obj: j,
                overrideContext: k
            })
        }
    },
    unsubscribe: function (o, m, k) {
        this.__yui_events = this.__yui_events || {};
        var j = this.__yui_events;
        if (o) {
            var l = j[o];
            if (l) {
                return l.unsubscribe(m, k)
            }
        } else {
            var h = true;
            for (var n in j) {
                if (YAHOO.lang.hasOwnProperty(j, n)) {
                    h = h && j[n].unsubscribe(m, k)
                }
            }
            return h
        }
        return false
    },
    unsubscribeAll: function (b) {
        return this.unsubscribe(b)
    },
    createEvent: function (h, k) {
        this.__yui_events = this.__yui_events || {};
        var m = k || {}, n = this.__yui_events,
            l;
        if (n[h]) {} else {
            l = new YAHOO.util.CustomEvent(h, m.scope || this, m.silent, YAHOO.util.CustomEvent.FLAT, m.fireOnce);
            n[h] = l;
            if (m.onSubscribeCallback) {
                l.subscribeEvent.subscribe(m.onSubscribeCallback)
            }
            this.__yui_subscribers = this.__yui_subscribers || {};
            var j = this.__yui_subscribers[h];
            if (j) {
                for (var o = 0; o < j.length; ++o) {
                    l.subscribe(j[o].fn, j[o].obj, j[o].overrideContext)
                }
            }
        }
        return n[h]
    },
    fireEvent: function (e) {
        this.__yui_events = this.__yui_events || {};
        var g = this.__yui_events[e];
        if (!g) {
            return null
        }
        var f = [];
        for (var h = 1; h < arguments.length; ++h) {
            f.push(arguments[h])
        }
        return g.fire.apply(g, f)
    },
    hasEvent: function (b) {
        if (this.__yui_events) {
            if (this.__yui_events[b]) {
                return true
            }
        }
        return false
    }
};
(function () {
    var e = YAHOO.util.Event,
        f = YAHOO.lang;
    YAHOO.util.KeyListener = function (l, a, k, j) {
        if (!l) {} else {
            if (!a) {} else {
                if (!k) {}
            }
        } if (!j) {
            j = YAHOO.util.KeyListener.KEYDOWN
        }
        var c = new YAHOO.util.CustomEvent("keyPressed");
        this.enabledEvent = new YAHOO.util.CustomEvent("enabled");
        this.disabledEvent = new YAHOO.util.CustomEvent("disabled");
        if (f.isString(l)) {
            l = document.getElementById(l)
        }
        if (f.isFunction(k)) {
            c.subscribe(k)
        } else {
            c.subscribe(k.fn, k.scope, k.correctScope)
        }
        function b(r, s) {
            if (!a.shift) {
                a.shift = false
            }
            if (!a.alt) {
                a.alt = false
            }
            if (!a.ctrl) {
                a.ctrl = false
            }
            if (r.shiftKey == a.shift && r.altKey == a.alt && r.ctrlKey == a.ctrl) {
                var q, g = a.keys,
                    h;
                if (YAHOO.lang.isArray(g)) {
                    for (var p = 0; p < g.length; p++) {
                        q = g[p];
                        h = e.getCharCode(r);
                        if (q == h) {
                            c.fire(h, r);
                            break
                        }
                    }
                } else {
                    h = e.getCharCode(r);
                    if (g == h) {
                        c.fire(h, r)
                    }
                }
            }
        }
        this.enable = function () {
            if (!this.enabled) {
                e.on(l, j, b);
                this.enabledEvent.fire(a)
            }
            this.enabled = true
        };
        this.disable = function () {
            if (this.enabled) {
                e.removeListener(l, j, b);
                this.disabledEvent.fire(a)
            }
            this.enabled = false
        };
        this.toString = function () {
            return "KeyListener [" + a.keys + "] " + l.tagName + (l.id ? "[" + l.id + "]" : "")
        }
    };
    var d = YAHOO.util.KeyListener;
    d.KEYDOWN = "keydown";
    d.KEYUP = "keyup";
    d.KEY = {
        ALT: 18,
        BACK_SPACE: 8,
        CAPS_LOCK: 20,
        CONTROL: 17,
        DELETE: 46,
        DOWN: 40,
        END: 35,
        ENTER: 13,
        ESCAPE: 27,
        HOME: 36,
        LEFT: 37,
        META: 224,
        NUM_LOCK: 144,
        PAGE_DOWN: 34,
        PAGE_UP: 33,
        PAUSE: 19,
        PRINTSCREEN: 44,
        RIGHT: 39,
        SCROLL_LOCK: 145,
        SHIFT: 16,
        SPACE: 32,
        TAB: 9,
        UP: 38
    }
})();
YAHOO.register("event", YAHOO.util.Event, {
    version: "2.9.0",
    build: "2800"
});

function XMLLoader() {
    var b;
    var e;
    var d;
    var j;
    var a;
    this.loadXML = function (l, k, m) {
        b = k;
        e = m;
        a = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");
        a.onreadystatechange = g;
        a.open("GET", l, true);
        a.send("")
    };
    var g = function () {
        if (a.readyState == 4 && (a.status == 200 || a.status == 304)) {
            if (e) {
                f(a.responseXML)
            }
            j = a.responseXML;
            if (typeof (b) == "object") {
                b.fnc.call(b.obj, j)
            } else {
                if (typeof (b) == "function") {
                    b(j)
                } else {
                    if (typeof (b) == "string") {
                        RotateTool.xmlLoaded(b, j)
                    } else {
                        alert("undefined type of functionToCall")
                    }
                }
            }
        } else {}
    };
    var f = function (k) {
        d = Array();
        h(k, 0);
        for (i = d.length - 1; i >= 0; i--) {
            nodeRef = d[i];
            nodeRef.parentNode.removeChild(nodeRef)
        }
    };
    var h = function (k, l) {
        for (i = 0; i < k.childNodes.length; i++) {
            if (k.childNodes[i].nodeType == 3 && c(k.childNodes[i])) {
                d[d.length] = k.childNodes[i]
            }
            if (k.childNodes[i].hasChildNodes()) {
                h(k.childNodes[i], i)
            }
        }
        k = k.parentNode;
        i = l
    };
    var c = function (k) {
        return !(/[^\t\n\r ]/.test(k.data))
    }
};